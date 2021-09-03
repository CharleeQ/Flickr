//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getRecentPhotos(extras: String = "",
                         perPage: Int = 100,
                         page: Int = 1,
                         completion: @escaping (Result<String, Error>) -> Void) {
        request(method: "flickr.photos.getRecent", parameters: [.per_page: perPage,
                                                                .page: page,
                                                                .extras: extras]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhotoInfo(photoID: String,
                      secret: String = "",
                      completion: @escaping (Result<String, Error>) -> Void) {
        request(method: "flickr.photos.getInfo", parameters: [.photo_id: photoID,
                                                              .secret: secret]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deletePhoto(photoID: String, completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.photos.delete", parameters: [.photo_id: photoID]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
