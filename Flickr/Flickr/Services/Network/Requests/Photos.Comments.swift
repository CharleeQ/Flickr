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
                parameters: [.photo_id: photoID],
                serializer: JSONSerializer<CommentsFlickrApi>()) { result in
            completion(result.map { $0.comments.comment })
        }
    }
    
    func addComment(photoID: String,
                    commentText: String,
                    completion: @escaping (Result<AddedComment, Error>) -> Void) {
        requestWithOAuth(http: .POST,
                         method: "flickr.photos.comments.addComment",
                         parameters: [.photo_id: photoID, .comment_text: commentText],
                         serializer: JSONSerializer<AddCommentFlickrApi>()) { result in
            completion(result.map { $0.comment })
        }
    }
    
    func deleteComment(photoID: String,
                       commentID: String,
                       completion: @escaping (Result<Void, Error>) -> Void) {
        requestWithOAuth(http: .POST,
                         method: "flickr.photos.comments.deleteComment",
                         parameters: [.photo_id: photoID,
                                      .comment_id: commentID],
                         serializer: VoidSerializer(), completion: completion)
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
