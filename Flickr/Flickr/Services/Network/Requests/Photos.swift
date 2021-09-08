//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getRecentPhotos(extras: String?,
                         perPage: Int = 100,
                         page: Int = 1,
                         completion: @escaping (Result<[RecentPhoto], Error>) -> Void) {
        var params: [NetworkParameters: Any] = [.per_page: perPage, .page: page]
        if let extras = extras { params[.extras] = extras }
        
        request(method: "flickr.photos.getRecent",
                parameters: params,
                serializer: JSONSerializer<RecentFlickrApi>()) { result in
            switch result {
            case .success(let json):
                completion(.success(json.photos.photo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPhotoInfo(photoID: String,
                      secret: String?,
                      completion: @escaping (Result<Photo, Error>) -> Void) {
        var params: [NetworkParameters: Any] = [.photo_id: photoID]
        if let secret = secret { params[.secret] = secret }
        
        request(method: "flickr.photos.getInfo",
                parameters: params,
                serializer: JSONSerializer<PhotoFlickrApi>()) { result in
            switch result {
            case .success(let json):
                completion(.success(json.photo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deletePhoto(photoID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        requestWithOAuth(http: .POST,
                         method: "flickr.photos.delete",
                         parameters: [.photo_id: photoID],
                         serializer: VoidSerializer()) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct PhotoFlickrApi: Decodable {
    let photo: Photo
    let stat: String
}

private struct RecentFlickrApi: Decodable {
    let photos: Photos
    let stat: String
    
    struct Photos: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [RecentPhoto]
    }
}
