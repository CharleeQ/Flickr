//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getRecentPhotos(extras: String?,
                         perPage: Int = 20,
                         page: Int = 1,
                         completion: @escaping (Result<Photos, Error>) -> Void) {
        var params: [NetworkParameters: Any] = [.per_page: perPage, .page: page]
        if let extras = extras { params[.extras] = extras }
        
        request(method: "flickr.photos.getRecent",
                parameters: params,
                serializer: JSONSerializer<RecentFlickrApi>()) { result in
            completion(result.map { $0.photos })
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
            completion(result.map { $0.photo })
        }
    }
    
    func deletePhoto(photoID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        requestWithOAuth(http: .POST,
                         method: "flickr.photos.delete",
                         parameters: [.photo_id: photoID],
                         serializer: VoidSerializer(), completion: completion)
    }
}

private struct PhotoFlickrApi: Decodable {
    let photo: Photo
    let stat: String
}

private struct RecentFlickrApi: Decodable {
    let photos: Photos
    let stat: String
}
