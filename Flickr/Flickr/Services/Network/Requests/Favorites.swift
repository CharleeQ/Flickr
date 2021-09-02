////
////  Favorites.swift
////  Flickr
////
////  Created by Кирилл Какареко on 01.09.2021.
////
//
//import Foundation
//
//extension NetworkService {
//    func getFavoriteList(userID: String,
//                         minFavoriteDate: Date? = nil,
//                         maxFavoriteDate: Date? = nil,
//                         extras: String = "",
//                         perPage: Int = 100,
//                         page: Int = 1,
//                         format: String = "json",
//                         completion: @escaping (Result<String, Error>) -> Void) {
//        var params = ["api_key": constants.consumerKey,
//                      "user_id": userID,
//                      "extras": extras,
//                      "per_page": String(perPage),
//                      "page": String(page),
//                      "method": "flickr.favorites.getList",
//                      "format": format]
//        if minFavoriteDate != nil { params["min_fave_date"] = String(minFavoriteDate!.timeIntervalSince1970) }
//        if maxFavoriteDate != nil { params["max_fave_date"] = String(maxFavoriteDate!.timeIntervalSince1970) }
//        
//        request(parameters: params) { result in
//            switch result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func addFavorite(photoID: String,
//                     format: String = "json",
//                     completion: @escaping (Result<String, Error>) -> Void) {
//        let params = ["oauth_consumer_key": constants.consumerKey,
//                      "oauth_nonce": constants.nonce,
//                      "oauth_timestamp": constants.timestamp,
//                      "oauth_signature_method": "HMAC-SHA1",
//                      "oauth_version": "1.0",
//                      "oauth_token": accessToken,
//                      "photo_id": photoID,
//                      "format": format,
//                      "method": "flickr.favorites.add"]
//        
//        request(http: .POST, parameters: params) { result in
//            switch result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//    
//    func removeFavorite(photoID: String,
//                        completion: @escaping (Result<String, Error>) -> Void) {
//        let params = ["oauth_consumer_key": constants.consumerKey,
//                      "oauth_nonce": constants.nonce,
//                      "oauth_timestamp": constants.timestamp,
//                      "oauth_signature_method": "HMAC-SHA1",
//                      "oauth_version": "1.0",
//                      "oauth_token": accessToken,
//                      "photo_id": photoID,
//                      "method": "flickr.favorites.remove"]
//        
//        request(http: .POST, parameters: params) { result in
//            switch result {
//            case .success(let data):
//                completion(.success(data))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
//}
