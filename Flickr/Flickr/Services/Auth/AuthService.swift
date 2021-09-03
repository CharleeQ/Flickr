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
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping ((Result<[String: String], Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data) { result in
                    switch result {
                    case .success(let tokens):
                        self.exchangingTheRequestForAccess(request: tokens.0, verifier: tokens.1) { result in
                            switch result {
                            case .success(let tokens):
                                completion(.success(tokens))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Private functions
    
    private func signWithURL(path: String, state: OAuthRequestState, parameters: [OAuthParameters:String], method: HTTPMethod = .GET) -> URL? {
        print(">> \(state.description.uppercased()) SIGNATURE: ")
        let base = (path + "/" + state.description).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var params = parameters.sorted { $0.0.rawValue < $1.0.rawValue }.map { (key, value) -> String in
            return "\(key.rawValue)%3D\(value)%26"
        }
        let string = "\(method.rawValue)&\(base)&\(params.joined().dropLast(3))"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret ?? "")")
        print(encryptString)
        params.append("\(OAuthParameters.oauth_signature)=\(encryptString)")
        let urlString = path + "/" + state.description + "?" + params.joined()
        let url = URL(string: urlString.removingPercentEncoding!)
        
        return url
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
    
    // First step
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let params: [OAuthParameters: String] = [.oauth_callback: "\(constants.callbackScheme)%253A%252F%252F",
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
    
    // Second step
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
    
    // Third step
    private func exchangingTheRequestForAccess(request: String, verifier: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
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
                completion(.success(tokens))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

