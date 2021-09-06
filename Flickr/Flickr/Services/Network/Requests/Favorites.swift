//
//  Favorites.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getFavoriteList(userID: String,
                         extras: String = "",
                         perPage: Int = 100,
                         page: Int = 1,
                         completion: @escaping (Result<[FaveFlickrApi.Photos.Photo], Error>) -> Void) {
        request(method: "flickr.favorites.getList", parameters: [.user_id: userID,
                                                                 .per_page: perPage,
                                                                 .page: page,
                                                                 .extras: extras]) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let json = try decoder.decode(FaveFlickrApi.self, from: data)
                    completion(.success(json.photos.photo))
                } catch let error {
                    completion(.failure(error))
                }
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
//                print(String.init(data: data, encoding: .utf8))
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(AddFaveFlickrApi.self, from: data)
                    completion(.success(json.stat))
                } catch let error {
                    completion(.failure(error))
                }
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
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(RemoveFaveFlickrApi.self, from: data)
                    completion(.success(json.stat))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
