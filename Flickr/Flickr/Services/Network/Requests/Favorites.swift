//
//  Favorites.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getFavoriteList(userID: String,
                         minFavoriteDate: Date? = nil,
                         maxFavoriteDate: Date? = nil,
                         extras: String = "",
                         perPage: Int = 100,
                         page: Int = 1,
                         completion: @escaping (Result<String, Error>) -> Void) {
        request(method: "flickr.favorites.getList", parameters: [.user_id: userID,
                                                                 .per_page: perPage,
                                                                 .page: page,
                                                                 .extras: extras/*,
                                                                 .min_fave_date: minFavoriteDate?.timeIntervalSince1970 ?? "",
                                                                 .max_fave_date: maxFavoriteDate?.timeIntervalSince1970 ?? ""*/]) { result in
            switch result {
            case .success(let data):
                completion(.success(data.base64EncodedString()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addFavorite(photoID: String,
                     completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.favorites.add", parameters: [.photo_id: photoID]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFavorite(photoID: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.favorites.remove", parameters: [.photo_id: photoID]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
