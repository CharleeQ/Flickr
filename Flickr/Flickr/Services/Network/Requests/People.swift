//
//  People.swift
//  Flickr
//
//  Created by Кирилл Какареко on 02.09.2021.
//

import Foundation

extension NetworkService {
    func getPhotos(userID: String,
                   safeSearch: Int = 1,
                   minUploadDate: Date? = nil,
                   maxUploadDate: Date? = nil,
                   minTakenDate: Date? = nil,
                   maxTakenDate: Date? = nil,
                   contentType: Int = 7,
                   privacyFilter: Int = 1,
                   extras: String = "",
                   perPage: Int = 100,
                   page: Int = 1,
                   completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["oauth_consumer_key": consumerKey,
                      "oauth_nonce": nonce,
                      "oauth_timestamp": timestamp,
                      "oauth_signature_method": "HMAC-SHA1",
                      "oauth_version": "1.0",
                      "oauth_token": accessToken,
                      "method": "flickr.favorites.remove"]
        
        request(http: .POST, parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
