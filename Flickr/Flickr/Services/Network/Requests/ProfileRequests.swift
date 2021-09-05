//
//  Profile.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

extension NetworkService {
    func getProfile(nsid: String,
                    completion: @escaping (Result<Profile, Error>) -> Void) {
        request(method: "flickr.profile.getProfile", parameters: [.user_id: nsid]) { result in
            switch result {
            case .success(let data):
                do {
                    let string = String(data: data, encoding: .utf8)
                    if let string = string {
                        print(string)
                    }
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let json = try decoder.decode(JsonFlickrApi.self, from: data)
                    
                    completion(.success(json.profile))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
