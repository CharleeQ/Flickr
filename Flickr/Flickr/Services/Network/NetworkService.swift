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
        
        let queryString = params
            .sorted(by: { $0.key < $1.key })
            .map { $0.key + "=" + "\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let signatureString = method.rawValue
            + "&" + path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            + "&" + queryString.addingPercentEncoding(withAllowedCharacters: .urlCharset)!
        let signature = signatureString.hmac(key: constants.consumerSecret + "&" + tokenSecret)
        let urlString = path + "?" + queryString
            + "&" + OAuthParameters.oauth_signature.rawValue + "=" + signature.addingPercentEncoding(withAllowedCharacters: .urlQueryWithPlusAllowed)!

        return URL(string: urlString)
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
