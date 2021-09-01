//
//  Profile.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

extension NetworkService {
    func getProfile(apiKey: String, nsid: String, completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": apiKey, "user_id": nsid]
        request(method: "flickr.profile.getProfile", parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
