//
//  Comments.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.09.2021.
//

import Foundation

struct CommentsFlickrApi: Decodable {
    let comments: Comments
    let stat: String
    
    struct Comments: Decodable {
        let photoID: String
        let comment: [Comment]
        
        enum CodingKeys: String, CodingKey {
            case photoID = "photo_id"
            case comment
        }
        
        struct Comment: Decodable {
            let id: String
            let author: String
            let authorIsDeleted: Int
            let authorname: String
            let iconserver: String
            let datecreate: String
            let realname: String
            let content: String
            
            enum CodingKeys: String, CodingKey {
                case id
                case author
                case authorIsDeleted = "author_is_deleted"
                case authorname
                case iconserver
                case datecreate
                case realname
                case content = "_content"
            }
        }
    }
}

struct AddCommentFlickrApi: Decodable {
    let comment: Comment
    let stat: String
    
    struct Comment: Decodable {
        let id: String
        let author: String
        let authorname: String
        let datecreate: String
        let realname: String
        let content: String
        let iconurls: IconURLs
        
        enum CodingKeys: String, CodingKey {
            case id
            case author
            case authorname
            case datecreate
            case realname
            case content = "_content"
            case iconurls
        }
        
        struct IconURLs: Decodable {
            let retina: String
            let large: String
            let medium: String
            let small: String
            let `default`: String
        }
    }
}

struct DeleteCommentFlickrApi: Decodable {
    let stat: String
}
