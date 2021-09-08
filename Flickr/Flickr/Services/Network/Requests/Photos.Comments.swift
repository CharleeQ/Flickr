//
//  Photos.Comments.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getCommentsList(photoID: String,
                         completion: @escaping (Result<[Comment], Error>) -> Void) {
        request(method: "flickr.photos.comments.getList",
                parameters: [.photo_id: photoID]) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(CommentsFlickrApi.self, from: data)
                    completion(.success(json.comments.comment))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addComment(photoID: String,
                    commentText: String,
                    completion: @escaping (Result<AddedComment, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.photos.comments.addComment",
                         parameters: [.photo_id: photoID,
                                      .comment_text: commentText]) { result in
            switch result {
            case .success(let data):
                
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(AddCommentFlickrApi.self, from: data)
                    completion(.success(json.comment))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteComment(photoID: String,
                       commentID: String,
                       completion: @escaping (Result<String, Error>) -> Void) {
        requestWithOAuth(http: .POST, method: "flickr.photos.comments.deleteComment",
                         parameters: [.photo_id: photoID,
                                      .comment_id: commentID]) { result in
            switch result {
            case .success( _):
                completion(.success("ok"))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct CommentsFlickrApi: Decodable {
    let comments: Comments
    let stat: String
    
    struct Comments: Decodable {
        let photoID: String
        let comment: [Comment]
        
        enum CodingKeys: String, CodingKey {
            case photoID = "photo_id"
            case comment
        }
    }
}

private struct AddCommentFlickrApi: Decodable {
    let comment: AddedComment
    let stat: String
}
