//
//  Profile.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

extension NetworkService {
    func getProfile(completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": "1877653cabad94b4cd42e56f49689e6c", "user_id": "193759241%40N06"]
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
