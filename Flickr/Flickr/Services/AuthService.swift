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
    var signature: String {
        // Step zero: Signing requests
        let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3D\(callback)%253A%252F%252Fapp.com%26oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D\(nonce)%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
        let encryptString = string.hmac(key: "\(consumerSecret)&")
        print("[SIGNATURE]: " + encryptString)
        
        return encryptString
    }
    
    
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
        //kiryl://app.com?oauth_token=72157719725335319-78f57b08128fa85e&oauth_verifier=625c10dcf3cfcabd
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
        let url = URL(string: "https://www.flickr.com/services/oauth/access_token?oauth_nonce=\(nonce)&oauth_timestamp=1305586309&oauth_verifier=\(verifier)&oauth_consumer_key=\(consumerKey)&oauth_signature_method=HMAC-SHA1&oauth_version=1.0&oauth_token=\(token)&oauth_signature=\(signature)")
        if let url = url {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let urlRequest = URLRequest(url: url)
            session.dataTask(with: urlRequest) { data, response, error in
                print("SASI")
            }
        }
    }
}


//"https://www.flickr.com/services/oauth/request_token?oauth_callback=http://www.github.com&oauth_consumer_key=1877653cabad94b4cd42e56f49689e6c&oauth_nonce=956r13465&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=kDgmLbI4KS8KYmNv8OD1cR0ln74="
//"GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Fwww.github.com%26oauth_consumer_key%3D1877653cabad94b4cd42e56f49689e6c%26oauth_nonce%3D956r13465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
