//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getRecent(apiKey: String, extras: String? = nil, perPage: Int? = nil, page: Int? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var params = ["api_key": apiKey]
        if extras != nil { params["extras"] = extras }
        if perPage != nil { params["per_page"] = String(perPage!) }
        if page != nil { params["page"] = String(page!) }
        request(method: "flickr.photos.getRecent", parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getInfo(apiKey: String, photoID: String, secret: String? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var params = ["api_key": apiKey, "photo_id": photoID]
        if secret != nil { params["secret"] = secret }
        request(method: "flickr.photos.getInfo", parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
