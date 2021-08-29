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
    
    // MARK: - Intents
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding, completion: ((Result<String, Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data) { result in
                    switch result {
                    case .success(let tokens):
                        self.exchangingTheRequestForAccess(request: tokens.0, verifier: tokens.1)
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callTestAPI() {
        var sign: String {
            print("Access: \(accessToken!), Consumer: \(consumerKey), Secret: \(tokenSecret!)")
            let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Frest&format%3Djson%26method%3Dflickr.test.login%26nojsoncallback%3D1%26oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D8435e4935%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305583871%26oauth_token%3D\(accessToken!)%26oauth_version%3D1.0"
            return string.hmac(key: "\(consumerSecret)&\(tokenSecret!)")
        }
        
        let url = URL(string: "https://www.flickr.com/services/rest?nojsoncallback=1&oauth_nonce=8435e4935&format=json&oauth_consumer_key=\(consumerKey)&oauth_timestamp=1305583871&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_token=\(accessToken!)&oauth_signature=\(sign)&method=flickr.test.login")
        
        if let url = url {
            print(url.absoluteString)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let urlRequest = URLRequest(url: url)
            session.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    if let string = string {
                        print(string)
                    }
                }
            }.resume()
        }
    }
    
    
    // MARK: - Private functions
    
    private func signWithURL(path: String, state: OAuthRequestState, parameters: [OAuthParameters:String], method: HTTPMethod = .GET) -> URL? {
        print(">> \(state.description.uppercased()) SIGNATURE: ")
        let base = (path + "/" + state.description).addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let params = parameters.sorted { $0.0.description < $1.0.description }.map { (key, value) -> String in
            return "\(key.description)%3D\(value.description)%26"
        }
        let string = "\(method.rawValue)&\(base ?? "")&\(params.joined().dropLast(3))"
        let encryptString = string.hmac(key: "\(consumerSecret)&\(tokenSecret ?? "")")
        print(encryptString)
        
        let urlString = path + "/" + state.description + "?" + params.joined() + OAuthParameters.signature.description + "=" + encryptString
        let url = URL(string: urlString.removingPercentEncoding ?? "")
        
        return url
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
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
                let requestToken = string.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_token_secret").first
                self.tokenSecret = string.components(separatedBy: "&oauth_token_secret=").last
                
                if let requestToken = requestToken {
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
            guard error == nil, let callbackURL = callbackURL else { return }
            
            print("Handle the Callback \(callbackURL.absoluteString)")
            let verifier = callbackURL.absoluteString.components(separatedBy: "verifier=").last
            let token = callbackURL.absoluteString.components(separatedBy: "?oauth_token=").last?.components(separatedBy: "&oauth_verifier").first
            if let verifier = verifier, let token = token {
                completion(.success((token, verifier)))
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
    private func exchangingTheRequestForAccess(request: String, verifier: String) {
        let params: [OAuthParameters: String] = [.consumerKey: consumerKey,
                                                 .nonce: nonce,
                                                 .signatureMethod: self.signatureMethod,
                                                 .timestamp: self.timestamp,
                                                 .version: self.version,
                                                 .verifier: verifier,
                                                 .token: request]
        guard let url = signWithURL(path: "https://www.flickr.com/services/oauth",
                                    state: .accessToken, parameters: params) else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                print(string)
                self.accessToken = string.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_token_secret").first
                self.tokenSecret = string.components(separatedBy: "&oauth_token_secret=").last?.components(separatedBy: "&user_nsid").first
            } else if let error = error {
                print(error)
            }
        }.resume()
        
    }
}
