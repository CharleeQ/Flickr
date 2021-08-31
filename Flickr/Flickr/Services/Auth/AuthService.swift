//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

private enum OAuthParameters: String {
    case nonce
    case timestamp
    case consumerKey
    case signatureMethod
    case version
    case callback
    case signature
    case token
    case permissions
    case verifier
    
    var description: String {
        switch self {
        case .nonce:
            return "oauth_nonce"
        case .timestamp:
            return "oauth_timestamp"
        case .consumerKey:
            return "oauth_consumer_key"
        case .signatureMethod:
            return "oauth_signature_method"
        case .version:
            return "oauth_version"
        case .callback:
            return "oauth_callback"
        case .signature:
            return "oauth_signature"
        case .token:
            return "oauth_token"
        case .permissions:
            return "perms"
        case .verifier:
            return "oauth_verifier"
        }
    }
}

private enum OAuthRequestState: String {
    case requestToken, accessToken
    
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
    static let shared = AuthService()
    
    
    // MARK: - Parameters
    
    private let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
    private let consumerSecret = "f1938a9c14a1d472"
    private let version = "1.0"
    private let signatureMethod = "HMAC-SHA1"
    private let callbackScheme = "kiryl"
    private var nonce: String {
        let temp = UUID().uuidString
        let nonce = temp.replacingOccurrences(of: "-", with: "")
        
        return nonce
    }
    private var timestamp: String {
        return String(Date().timeIntervalSince1970)
    }
    
    
    // MARK: - Tokens
    
    private var accessToken: String?
    private var tokenSecret: String?
    
    
    // MARK: - Session
    
    private let session = URLSession(configuration: .default)
    
    
    // MARK: - Intents
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding, completion: @escaping ((Result<String, Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data) { result in
                    switch result {
                    case .success(let tokens):
                        self.exchangingTheRequestForAccess(request: tokens.0, verifier: tokens.1) { result in
                            switch result {
                            case .success(let tokens):
                                self.accessToken = tokens.0
                                self.tokenSecret = tokens.1
                                completion(.success(tokens.0))
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
        var params = parameters.sorted { $0.0.description < $1.0.description }.map { (key, value) -> String in
            return "\(key.description)%3D\(value.description)%26"
        }
        let string = "\(method.rawValue)&\(base)&\(params.joined().dropLast(3))"
        let encryptString = string.hmac(key: "\(consumerSecret)&\(tokenSecret ?? "")")
        print(encryptString)
        params.append("\(OAuthParameters.signature.description)=\(encryptString)")
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
        print(dict)
        
        return dict
    }
    
    
    // MARK: - Authorization steps
    
    // First step
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let params: [OAuthParameters: String] = [.callback: "\(callbackScheme)%253A%252F%252F",
                                                 .consumerKey: consumerKey,
                                                 .nonce: nonce,
                                                 .signatureMethod: signatureMethod,
                                                 .timestamp: timestamp,
                                                 .version: version]
        guard let url = signWithURL(path: "https://www.flickr.com/services/oauth", state: .requestToken, parameters: params) else { return }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                let tokens = self.parsingTokens(of: string)
                
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
        guard let url = URL(string: "https://www.flickr.com/services/oauth/authorize?oauth_token=\(token)") else { return }
        
        let signSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callbackScheme) { callbackURL, error in
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
    private func exchangingTheRequestForAccess(request: String, verifier: String, completion: @escaping (Result<(String, String), Error>) -> Void) {
        let params: [OAuthParameters: String] = [.consumerKey: consumerKey,
                                                 .nonce: nonce,
                                                 .signatureMethod: signatureMethod,
                                                 .timestamp: timestamp,
                                                 .version: version,
                                                 .verifier: verifier,
                                                 .token: request]
        guard let url = signWithURL(path: "https://www.flickr.com/services/oauth",
                                    state: .accessToken, parameters: params) else { return }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
                let tokens = self.parsingTokens(of: string)
                if let access = tokens["oauth_token"], let secret = tokens["oauth_token_secret"] {
                    completion(.success((access, secret)))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

