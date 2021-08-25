//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

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
    private var tokenSecret: String?
    
    // MARK: - Public functions
    
    func login(presenter: UIViewController, completion: ((Result<String, Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func handleURL(url: URL) {
        print("Handle the Callback \(url.absoluteString)")
        let verifier = url.absoluteString.components(separatedBy: "verifier=").last
        let token = url.absoluteString.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_verifier").first
        if let verifier = verifier, let token = token {
            exchangeTokens(token: token, verifier: verifier)
        }
    }
    
    
    // MARK: - Steps
    
    // First step
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://www.flickr.com/services/oauth/request_token?oauth_callback=\(callback)://app.com&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=\(signature)")
        if let url = url {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let urlRequest = URLRequest(url: url)
            session.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    let requestToken = string?.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_token_secret").first
                    self.tokenSecret = string?.components(separatedBy: "&oauth_token_secret=").last
                    if let requestToken = requestToken {
                        completion(.success(requestToken))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
            
        }
    }
    
    // Second step
    private func getTheUserAuthorization(presenter: UIViewController, token: String) {
        let url = URL(string: "https://www.flickr.com/services/oauth/authorize?oauth_token=\(token)")
        if let url = url {
            let signSession = ASWebAuthenticationSession(url: url, callbackURLScheme: callback) { callbackURL, error in
                guard error == nil, let callbackURL = callbackURL else { return }
                
                self.handleURL(url: callbackURL)
            }
            signSession.presentationContextProvider = presenter as? ASWebAuthenticationPresentationContextProviding
            signSession.start()
        }
    }
    
    // Third step
    private func exchangeTokens(token: String, verifier: String) {
        var sign: String {
            let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Faccess_token&oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D956w13465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586309%26oauth_token%3D\(token)%26oauth_verifier%3D\(verifier)%26oauth_version%3D1.0"
            return string.hmac(key: "\(consumerSecret)&\(tokenSecret)")
        }
        
        let url = URL(string: "https://www.flickr.com/services/oauth/access_token?oauth_nonce=956w13465&oauth_timestamp=1305586309&oauth_verifier=\(verifier)&oauth_consumer_key=\(consumerKey)&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_token=\(token)&oauth_signature=\(sign)")
        if let url = url {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let urlRequest = URLRequest(url: url)
            session.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    print(string)
                } else if let error = error {
                    print(error)
                }
            }.resume()
        }
    }
}
