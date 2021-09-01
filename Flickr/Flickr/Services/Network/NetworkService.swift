//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    let session = URLSession(configuration: .default)
    
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
