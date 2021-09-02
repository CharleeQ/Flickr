//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    let session = URLSession(configuration: .default)
    
    let constants = Constants()
    let tokenSecret: String
    let accessToken: String
    
    private let path = "https://www.flickr.com/services/rest"
    
    init(accessToken: String, tokenSecret: String) {
        self.accessToken = accessToken
        self.tokenSecret = tokenSecret
    }
    
    func signWithURL(parameters: [NetworkParameters: Any], method: HTTPMethod = .GET) -> URL? {
        var params: [String: Any] = [:]
        parameters.forEach { key, value in
            params[key.rawValue] = value
        }
        params[OAuthParameters.oauth_consumer_key.rawValue] = constants.consumerKey
        params[OAuthParameters.oauth_nonce.rawValue] = constants.nonce
        params[OAuthParameters.oauth_signature_method.rawValue] = constants.signatureMethod
        params[OAuthParameters.oauth_timestamp.rawValue] = constants.timestamp
        params[OAuthParameters.oauth_version.rawValue] = constants.version
        
        
        let base = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var paramsString = parameters
            .sorted { $0.key.rawValue < $1.key.rawValue }
            .map { (key, value) in "\(key)%3D\(value)" }
            .joined(separator: "%26")
        
        let string = "\(method.rawValue)&\(base)&\(paramsString)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret)")
        print(encryptString)
        paramsString.append("&\(OAuthParameters.oauth_signature.rawValue)=\(encryptString)")
        let urlString = base + "?" + paramsString
        let url = URL(string: urlString.removingPercentEncoding!)
        
        return url
    }
    
    
    // MARK: - Request without OAuth
    
    func request(http: HTTPMethod = .GET, method: String, parameters: [NetworkParameters: Any], completion: @escaping (Result<String, Error>) -> Void) {
        var params = parameters
        params[.format] = "json"
        params[.method] = method
        params[.api_key] = constants.consumerKey
        let paramsString = params.map { (key, value) in "\(key.rawValue)=\(value)" }
            .joined(separator: "&")
        
        let urlString = "\(path)?\(paramsString)"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = http.rawValue
            
            session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    if let string = string {
                        completion(.success(string))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    // MARK: - Request with OAuth
    
    func requestWithOAuth(http: HTTPMethod = .GET, parameters: [NetworkParameters: String], completion: @escaping (Result<String, Error>) -> Void) {
        
        if let url = signWithURL(parameters: parameters, method: http) {
            var request = URLRequest(url: url)
            request.httpMethod = "\(http.rawValue)"
            
            session.dataTask(with: request) { data, response, error in
                if let data = data {
                    let string = String(data: data, encoding: .utf8)
                    if let string = string {
                        completion(.success(string))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
