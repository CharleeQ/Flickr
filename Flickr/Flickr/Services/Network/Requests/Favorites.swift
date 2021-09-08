//
//  Favorites.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getFavoriteList(userID: String,
                         extras: String?,
                         perPage: Int = 100,
                         page: Int = 1,
                         completion: @escaping (Result<[FavoritePhoto], Error>) -> Void) {
        var params: [NetworkParameters: Any] = [.user_id: userID,
                                                .per_page: perPage,
                                                .page: page]
        if let extras = extras { params[.extras] = extras }
        
        request(method: "flickr.favorites.getList", parameters: params) { result in
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
            case .success(_):
                completion(.success("Added"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func removeFavorite(photoID: String,
                        completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.favorites.remove", parameters: [.photo_id: photoID]) { result in
            switch result {
            case .success(_):
                completion(.success("Removed"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct FaveFlickrApi: Decodable {
    let photos: Photos
    let stat: String
    
    struct Photos: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [FavoritePhoto]
    }
}
