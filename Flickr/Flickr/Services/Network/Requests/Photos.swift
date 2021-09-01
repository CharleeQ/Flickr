//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getRecentPhotos(extras: String = "", perPage: Int = 100, page: Int = 1, format: String = "json", completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": consumerKey,
                      "per_page": String(perPage),
                      "page": String(page),
                      "method": "flickr.photos.getRecent",
                      "format": format,
                      "extras": extras]
        request(parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhotoInfo(photoID: String, secret: String = "", format: String = "json", completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": consumerKey,
                      "photo_id": photoID,
                      "secret": secret,
                      "method": "flickr.photos.getInfo",
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
