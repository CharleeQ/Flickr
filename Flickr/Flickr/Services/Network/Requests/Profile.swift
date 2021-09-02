//
//  Profile.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

extension NetworkService {
    func getProfile(nsid: String,
                    format: String = "json",
                    completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": consumerKey,
                      "user_id": nsid,
                      "method": "flickr.profile.getProfile",
                      "format": format]
        request(parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
