//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

private enum OAuthParameters: String {
    case nonce = "oauth_nonce"
    case timestamp = "oauth_timestamp"
    case consumerKey = "oauth_consumer_key"
    case signatureMethod = "oauth_signature_method"
    case version = "oauth_version"
    case callback = "oauth_callback"
    case signature = "oauth_signature"
    case token = "oauth_token"
    case permissions = "perms"
    case verifier = "oauth_verifier"
}

class AuthService {
    static let shared = AuthService()
    
    
    // MARK: - Parameters
    
    private let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
    private let consumerSecret = "f1938a9c14a1d472"
    private let callback = "kiryl"
    private let nonce = "956w13465"
    private var signature: String {
        // Step zero: Signing requests
        let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3D\(callback)%253A%252F%252Fapp.com%26oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D\(nonce)%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
        let encryptString = string.hmac(key: "\(consumerSecret)&")
        print("[SIGNATURE]: " + encryptString)
        
        return encryptString
    }
    
    
    // MARK: - Tokens
    
    private var tokenSecret: String?
    private var accessToken: String?
    
    
    // MARK: - Public functions
    
    func login(presenter: ASWebAuthenticationPresentationContextProviding, completion: ((Result<String, Error>) -> Void)) {
        let params: [OAuthParameters: String] = [.callback: "\(callback)%253A%252F%252Fapp.com",.consumerKey: consumerKey,.nonce: nonce, .signatureMethod: "HMAC-SHA1", .timestamp: "1305586162",.version: "1.0"]
        _ = sign(path: "https://www.flickr.com/services/oauth/request_token", parameters: params)
        
        
        
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
    
    private func sign(path: String, parameters: [OAuthParameters:String], method: HTTPMethod = .GET) -> String {
        //        var sign: String {
        //            print("[SIGNATURE FOR EXCHANGE]: ")
        //            print("Token Secret: \(tokenSecret!), Token: \(token), Verifier: \(verifier)")
        //            let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Faccess_token&oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D9q5613465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586309%26oauth_token%3D\(token)%26oauth_verifier%3D\(verifier)%26oauth_version%3D1.0"
        //            return string.hmac(key: "\(consumerSecret)&\(tokenSecret!)")
        //        }
        print("[SIGNATURE]: ")
        print("> Base string: ")
        let base = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print(base ?? "NIL")
        
        print("> Parameters: ")
        let params = parameters.sorted { $0.0.rawValue < $1.0.rawValue }.map { (key, value) -> String in
            return "\(key)%3D\(value)%26"
        }
        print(params)
        print("> Total string: ")
        let string = "\(method.rawValue)&\(base ?? "")&\(params)"
        print(string)
        print("> Signature string: ")
        let encryptString = string.hmac(key: "\(consumerKey)&\(tokenSecret ?? "")")
        print(encryptString)
        
        return encryptString
    }
    
    
    // MARK: - Authorization steps
    
    // First step
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://www.flickr.com/services/oauth/request_token?oauth_callback=\(callback)://app.com&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=\(signature)") else { return }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, _, error in
            if let data = data {
                guard let string = String(data: data, encoding: .utf8) else { return }
                
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
        
        let signSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callback) { callbackURL, error in
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
        var sign: String {
            print("[SIGNATURE FOR EXCHANGE]: ")
            print("Token Secret: \(tokenSecret!), Token: \(request), Verifier: \(verifier)")
            let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Faccess_token&oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D9q5613465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586309%26oauth_token%3D\(request)%26oauth_verifier%3D\(verifier)%26oauth_version%3D1.0"
            return string.hmac(key: "\(consumerSecret)&\(tokenSecret!)")
        }
        
        guard let url = URL(string: "https://www.flickr.com/services/oauth/access_token?oauth_nonce=9q5613465&oauth_timestamp=1305586309&oauth_verifier=\(verifier)&oauth_consumer_key=\(consumerKey)&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_token=\(request)&oauth_signature=\(sign)") else { return }
        
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
