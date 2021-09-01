//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    let session = URLSession(configuration: .default)
    
    let consumerKey: String = "1877653cabad94b4cd42e56f49689e6c"
    let consumerSecret: String = "f1938a9c14a1d472"
    let accessToken: String
    let tokenSecret: String
    var nonce: String {
        let temp = UUID().uuidString
        let nonce = temp.replacingOccurrences(of: "-", with: "")
        
        return nonce
    }
    var timestamp: String {
        return String(Date().timeIntervalSince1970)
    }
    
    init(accessToken: String, tokenSecret: String) {
        self.accessToken = accessToken
        self.tokenSecret = tokenSecret
    }
    
    private func signWithURL(parameters: [String:String], method: HTTPMethod = .GET) -> URL? {
        let base = "https://www.flickr.com/services/rest".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var params = parameters
            .sorted { $0.key < $1.key }
            .map { (key, value) in "\(key)%3D\(value)" }
            .joined(separator: "%26")
        
        let string = "\(method.rawValue)&\(base)&\(params)"
        let encryptString = string.hmac(key: "\(consumerSecret)&\(tokenSecret)")
        print(encryptString)
        params.append("&oauth_signature=\(encryptString)")
        let urlString = base + "?" + params
        let url = URL(string: urlString.removingPercentEncoding!)

        return url
    }
    
    func request(http: HTTPMethod = .GET, parameters: [String: String], completion: @escaping (Result<String, Error>) -> Void) {
        
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
