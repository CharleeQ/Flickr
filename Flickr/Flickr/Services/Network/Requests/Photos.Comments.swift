//
//  Photos.Comments.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getCommentsList(photoID: String, minCommentDate: Date? = nil, maxCommentDate: Date? = nil, format: String = "json", completion: @escaping (Result<String, Error>) -> Void) {
        var params = ["api_key": consumerKey,
                      "photo_id": photoID,
                      "method": "flickr.photos.comments.getList",
                      "format": format]
        if minCommentDate != nil { params["min_comment_date"] = String(minCommentDate!.timeIntervalSince1970) }
        if maxCommentDate != nil { params["max_comment_date"] = String(maxCommentDate!.timeIntervalSince1970) }
        request(parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addComment(photoID: String, commentText: String, format: String = "json", completion: @escaping (Result<String, Error>) -> Void) {
        
        let params = ["oauth_consumer_key": consumerKey,
                      "oauth_nonce": nonce,
                      "oauth_timestamp": timestamp,
                      "oauth_signature_method": "HMAC-SHA1",
                      "oauth_version": "1.0",
                      "oauth_token": accessToken,
                      "photo_id": photoID,
                      "comment_text": commentText,
                      "format": format,
                      "method": "flickr.photos.comments.addComment"]
        
        request(http: .POST, parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteComment(photoID: String, commentID: String, format: String = "json", completion: @escaping (Result<String, Error>) -> Void) {
        
        let params = ["oauth_consumer_key": consumerKey,
                      "oauth_nonce": nonce,
                      "oauth_timestamp": timestamp,
                      "oauth_signature_method": "HMAC-SHA1",
                      "oauth_version": "1.0",
                      "oauth_token": accessToken,
                      "photo_id": photoID,
                      "comment_id": commentID,
                      "format": format,
                      "method": "flickr.photos.comments.deleteComment"]
        
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
