//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

private enum OAuthRequestState: String {
    case requestToken
    case accessToken
    
    var description: String {
        switch self {
        case .requestToken:
            return "request_token"
        case .accessToken:
            return "access_token"
        }
    }
}

class AuthService {
    private let constants = Constants()
    private var tokenSecret: String?
    
    
    // MARK: - Session
    
    private let session = URLSession(configuration: .default)
    
    
    // MARK: - Intents
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping ((Result<AuthUser, Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data) { result in
                    switch result {
                    case .success(let tokens):
                        self.exchangingTheRequestForAccess(request: tokens.0, verifier: tokens.1) { result in
                            switch result {
                            case .success(let user):
                                print(user)
                                DispatchQueue.main.async {
                                    completion(.success(user))
                                }
                            case .failure(let error):
                                DispatchQueue.main.async {
                                    completion(.failure(error))
                                }
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    // MARK: - Private functions
    
    private func signWithURL(path: String, state: OAuthRequestState, parameters: [OAuthParameters:String], method: HTTPMethod = .GET) -> URL? {
        let base = (path + "/" + state.description)
            .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var params = parameters
            .sorted { $0.0.rawValue < $1.0.rawValue }
            .map { (key, value) -> String in "\(key.rawValue)=\(value)" }
            .joined(separator: "&")
        
        let string = "\(method.rawValue)&\(base)&\(params.addingPercentEncoding(withAllowedCharacters: .urlCharset)!)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret ?? "")")
        print(encryptString)
        params.append("&\(OAuthParameters.oauth_signature)=\(encryptString.addingPercentEncoding(withAllowedCharacters: .urlQueryWithPlusAllowed)!)")
        let urlString = path + "/" + state.description + "?" + params
        
        return URL(string: urlString)
    }
    
    private func parsingTokens(of string: String) -> [String: String] {
        let sliceItems = string.split(separator: "&")
        var dict = [String:String]()
        for item in sliceItems {
            let split = item.split(separator: "=")
            if split.count == 2 {
                dict[String(split.first!)] = String(split.last!)
            }
        }
        
        return dict
    }
    
    
    // MARK: - Authorization steps
    
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let params: [OAuthParameters: String] = [.oauth_callback: "\(constants.callbackScheme)://"
                                                    .addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!,
                                                 .oauth_consumer_key: constants.consumerKey,
                                                 .oauth_nonce: constants.nonce,
                                                 .oauth_signature_method: constants.signatureMethod,
                                                 .oauth_timestamp: constants.timestamp,
                                                 .oauth_version: constants.version]
        guard let url = signWithURL(path: "https://www.flickr.com/services/oauth", state: .requestToken, parameters: params) else { return }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                let tokens = self.parsingTokens(of: string)
                print(tokens)
                self.tokenSecret = tokens["oauth_token_secret"]
                
                if let requestToken = tokens["oauth_token"] {
                    completion(.success(requestToken))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    
    private func getTheUserAuthorization(presenter: ASWebAuthenticationPresentationContextProviding, token: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: "https://www.flickr.com/services/oauth/authorize?oauth_token=\(token)&\(OAuthParameters.perms.rawValue)=\(constants.perms)") else { return }
        
        let signSession = ASWebAuthenticationSession(url: url, callbackURLScheme: constants.callbackScheme) { callbackURL, error in
            if let callbackURL = callbackURL {
                let tokens = self.parsingTokens(of: callbackURL.query ?? "")
                if let token = tokens["oauth_token"], let verifier = tokens["oauth_verifier"] {
                    completion(.success((token, verifier)))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        DispatchQueue.main.async {
            signSession.presentationContextProvider = presenter
            signSession.start()
        }
    }
    
    private func exchangingTheRequestForAccess(request: String, verifier: String, completion: @escaping (Result<AuthUser, Error>) -> Void) {
        let params: [OAuthParameters: String] = [.oauth_consumer_key: constants.consumerKey,
                                                 .oauth_nonce: constants.nonce,
                                                 .oauth_signature_method: constants.signatureMethod,
                                                 .oauth_timestamp: constants.timestamp,
                                                 .oauth_version: constants.version,
                                                 .oauth_verifier: verifier,
                                                 .oauth_token: request]
        guard let url = signWithURL(path: "https://www.flickr.com/services/oauth",
                                    state: .accessToken, parameters: params) else { return }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
                let tokens = self.parsingTokens(of: string)
                let userInfo = AuthUser(token: tokens["oauth_token"] ?? "unknown",
                                        tokenSecret: tokens["oauth_token_secret"] ?? "unknown",
                                        nsid: tokens["user_nsid"] ?? "unknown",
                                        username: tokens["username"] ?? "unknown",
                                        fullname: tokens["fullname"]?.removingPercentEncoding ?? "unknown")
                UserSettings.authUser = userInfo
                completion(.success(userInfo))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

