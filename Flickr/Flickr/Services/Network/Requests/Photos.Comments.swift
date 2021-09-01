//
//  Photos.Comments.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getCommentsList(apiKey: String, photoID: String, minCommentDate: Date? = nil, maxCommentDate: Date? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var params = ["api_key": apiKey, "photo_id": photoID]
        if minCommentDate != nil { params["min_comment_date"] = String(minCommentDate!.timeIntervalSince1970) }
        if maxCommentDate != nil { params["max_comment_date"] = String(maxCommentDate!.timeIntervalSince1970) }
        request(method: "flickr.photos.comments.getList", parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
