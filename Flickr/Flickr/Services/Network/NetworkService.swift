//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    private let session = URLSession(configuration: .default)
    
    let constants = Constants()
    let tokenSecret: String
    let accessToken: String
    
    private let path = "https://www.flickr.com/services/rest"
    
    init(accessToken: String, tokenSecret: String) {
        self.accessToken = accessToken
        self.tokenSecret = tokenSecret
    }
    
    private func signWithURL(parameters: [NetworkParameters: Any], method: HTTPMethod = .GET) -> URL? {
        var params: [String: Any] = [:]
        parameters.forEach { key, value in
            params[key.rawValue] = value
        }
        params[OAuthParameters.oauth_consumer_key.rawValue] = constants.consumerKey
        params[OAuthParameters.oauth_nonce.rawValue] = constants.nonce
        params[OAuthParameters.oauth_signature_method.rawValue] = constants.signatureMethod
        params[OAuthParameters.oauth_timestamp.rawValue] = constants.timestamp
        params[OAuthParameters.oauth_version.rawValue] = constants.version
        params[OAuthParameters.oauth_token.rawValue] = accessToken
        
        
        let base = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var paramsString = params
            .sorted { $0.key < $1.key }
            .map { (key, value) in
                "\(key)=\(value)".replacingOccurrences(of: " ", with: "%20")
            }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: constants.urlCharset)!
        let string = "\(method.rawValue)&\(base)&\(paramsString)"
        let encryptString = string.hmac(key: "\(constants.consumerSecret)&\(tokenSecret)")
        paramsString.append("&\(OAuthParameters.oauth_signature.rawValue)=\(encryptString)")
        let urlString = base + "?" + paramsString
        let url = URL(string: urlString
                        .removingPercentEncoding!
                        .replacingOccurrences(of: "+", with: "%2B"))
        
        return url
    }
    
    
    // MARK: - Request without OAuth

    func request<Serializer>(http: HTTPMethod = .GET, method: String, parameters: [NetworkParameters: Any], serializer: Serializer, completion: @escaping (Result<Serializer.R, Error>) -> Void) where Serializer: SerializerProtocol {
        var params = parameters
        params[.format] = "json"
        params[.nojsoncallback] = "1"
        params[.method] = method
        params[.api_key] = constants.consumerKey
        let paramsString = params.map { (key, value) in "\(key.rawValue)=\(value)" }
            .joined(separator: "&")
        
        if let url = URL(string: "\(path)?\(paramsString)") {
            var request = URLRequest(url: url)
            request.httpMethod = http.rawValue
            
            session.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let result = try serializer.parse(data: data)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    // MARK: - Request with OAuth
    
    func requestWithOAuth<Serializer>(http: HTTPMethod = .GET, method: String, parameters: [NetworkParameters: Any], serializer: Serializer, completion: @escaping (Result<Serializer.R, Error>) -> Void) where Serializer: SerializerProtocol {
        var params = parameters
        params[.format] = "json"
        params[.nojsoncallback] = "1"
        params[.method] = method
        
        if let url = signWithURL(parameters: params, method: http) {
            print(url.absoluteString)
            var request = URLRequest(url: url)
            request.httpMethod = http.rawValue
            
            session.dataTask(with: request) { data, response, error in
                if let data = data {
                    do {
                        let result = try serializer.parse(data: data)
                        completion(.success(result))
                    } catch let error {
                        completion(.failure(error))
                    }
                } else if let error = error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
