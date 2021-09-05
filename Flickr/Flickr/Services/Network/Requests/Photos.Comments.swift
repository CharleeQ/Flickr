//
//  Photos.Comments.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getCommentsList(photoID: String,
                         minCommentDate: Date? = nil,
                         maxCommentDate: Date? = nil,
                         completion: @escaping (Result<String, Error>) -> Void) {
        request(method: "flickr.photos.comments.getList", parameters: [.photo_id: photoID /* ,
                                                                       .min_comment_date: minCommentDate?.timeIntervalSince1970 ?? "",
                                                                       .max_comment_date: maxCommentDate?.timeIntervalSince1970 ?? "" */]) { result in
            switch result {
            case .success(let data):
                completion(.success(data.base64EncodedString()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addComment(photoID: String,
                    commentText: String,
                    completion: @escaping (Result<String, Error>) -> Void) {        
        requestWithOAuth(http: .POST, method: "flickr.photos.comments.addComment", parameters: [.photo_id: photoID,
                                                                                                .comment_text: commentText]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteComment(photoID: String,
                       commentID: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.photos.comments.deleteComment", parameters: [.photo_id: photoID,
                                                                                          .comment_id: commentID]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
