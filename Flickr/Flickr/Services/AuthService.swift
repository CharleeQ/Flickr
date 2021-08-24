//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import SafariServices

class AuthService {
    static let shared = AuthService()
    
    // MARK: - Parameters
    private let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
    private let consumerSecret = "f1938a9c14a1d472"
    private let callback = "www.github.com"
    private let nonce = "956r13465"
    var signature: String {
        // Step zero: Signing requests
        let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252F\(callback)%26oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D\(nonce)%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
        let encryptString = string.hmac(key: "\(consumerSecret)&")
        print("[SIGNATURE]: " + encryptString)
        
        return encryptString
    }
    
    
    // MARK: - Tokens
    
    private var requestToken: String?
    private var tokenSecret: String?
    
    
    // MARK: - Public functions
    
    func login(presenter: UIViewController, completion: ((Result<String, Error>) -> Void)) {
        getARequestToken { result in
            switch result {
            case .success(let data):
                self.getTheUserAuthorization(presenter: presenter, token: data) { result in
                    switch result {
                    case .success(_):
                        self.exchangeTokens()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func handleURL(url: URL) {
        
    }
    
    
    // MARK: - Steps
    
    // First step
    private func getARequestToken(completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://www.flickr.com/services/oauth/request_token?oauth_callback=http://\(callback)&oauth_consumer_key=\(consumerKey)&oauth_nonce=\(nonce)&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=\(signature)")
        if let url = url {
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let urlRequest = URLRequest(url: url)
            session.dataTask(with: urlRequest) { data, _, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    AuthService.shared.requestToken = string?.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_token_secret").first
                    AuthService.shared.tokenSecret = string?.components(separatedBy: "&oauth_token_secret=").last
                    completion(.success(data.base64EncodedString()))
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
            
        }
    }
    
    // Second step
    private func getTheUserAuthorization(presenter: UIViewController, token: String, completion: @escaping ((Result<String, Error>) -> Void)) {
        if let requestToken = requestToken {
            let url = URL(string: "https://www.flickr.com/services/oauth/authorize?oauth_token=\(requestToken)")
            if let url = url {
                let vc = SFSafariViewController(url: url)
                DispatchQueue.main.async {
                    presenter.present(vc, animated: true)
                }
            }
        }
    }
    
    // Third step
    private func exchangeTokens() {
        
    }
}


//"https://www.flickr.com/services/oauth/request_token?oauth_callback=http://www.github.com&oauth_consumer_key=1877653cabad94b4cd42e56f49689e6c&oauth_nonce=956r13465&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=kDgmLbI4KS8KYmNv8OD1cR0ln74="
//"GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Fwww.github.com%26oauth_consumer_key%3D1877653cabad94b4cd42e56f49689e6c%26oauth_nonce%3D956r13465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
