//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    let accessToken: String
    
    let session = URLSession(configuration: .default)
    
    init(access: String) {
        accessToken = access
    }
    
    //    private func signWithURL(path: String = "https://www.flickr.com/services/rest", parameters: [String: String], method: HTTPMethod = .GET) -> URL? {
    //        print(">> SIGNATURE: ")
    //        let base = path.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    //        var params = parameters.sorted { $0.0 < $1.0 }.map { (key, value) -> String in
    //            return "\(key)%3D\(value)%26"
    //        }
    //        let string = "\(method.rawValue)&\(base)&\(params.joined().dropLast(3))"
    //        let encryptString = string.hmac(key: "\(consumerSecret)&\(tokenSecret ?? "")")
    //        print(encryptString)
    //        params.append("\(OAuthParameters.signature.description)=\(encryptString)")
    //        let urlString = path + "/" + state.description + "?" + params.joined()
    //        let url = URL(string: urlString.removingPercentEncoding!)
    //
    //        return url
    //    }
    
    func request(http: HTTPMethod = .GET, method: String, parameters: [String: String], completion: @escaping (Result<String, Error>) -> Void) {
        let params = parameters
            .map { (key, value) in "\(key)=\(value)" }
            .joined(separator: "&")
        let urlString = "https://www.flickr.com/services/rest/?method=\(method)&\(params)"
        
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.httpMethod = "\(http.rawValue)"
            
            session.dataTask(with: request) { data, _, error in
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
