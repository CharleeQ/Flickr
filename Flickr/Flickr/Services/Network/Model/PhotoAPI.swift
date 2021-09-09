//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import Foundation

struct Photo: Decodable {
    let id: String
    let secret: String
    let farm: Int
    let dateuploaded: String
    let isfavorite: Int
    let license: String
    let safetyLevel: String
    let rotation: Int
    let originalsecret: String
    let originalformat: String
    let owner: Owner
    let title: Title
    let description: Description
    let visibility: Visibility
    let dates: Dates
    let views: String
    let editability: Editability
    let publiceditability: Publiceditability
    let comments: Comments
    let media: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case farm
        case dateuploaded
        case isfavorite
        case license
        case safetyLevel = "safety_level"
        case rotation
        case originalsecret
        case originalformat
        case owner
        case title
        case description
        case visibility
        case dates
        case views
        case editability
        case publiceditability
        case comments
        case media
    }
    
    struct Owner: Decodable {
        let nsid: String
        let username: String
        let realname: String
        let location: String
        let iconserver: String
        let iconfarm: Int
        let pathAlias: String
        
        enum CodingKeys: String, CodingKey {
            case nsid
            case username
            case realname
            case location
            case iconserver
            case iconfarm
            case pathAlias = "path_alias"
        }
    }
    
    struct Title: Decodable {
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case content = "_content"
        }
    }
    
    struct Description: Decodable {
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case content = "_content"
        }
    }
    
    struct Visibility: Decodable {
        let ispublic: Int
        let isfriend: Int
        let isfamily: Int
    }
    
    struct Dates: Decodable {
        let posted: String
        let taken: String
        let takengranularity: Int
        let takenunknown: String
        let lastupdate: String
    }
    
    struct Editability: Decodable {
        let cancomment: Int
        let canaddmeta: Int
    }
    
    struct Publiceditability: Decodable {
        let cancomment: Int
        let canaddmeta: Int
    }
    
    struct Comments: Decodable {
        let content: String
        
        enum CodingKeys: String, CodingKey {
            case content = "_content"
        }
    }
}

struct RecentPhoto: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
}