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
    let server: String
    let farm: Int
    let dateuploaded: Date
    let isfavorite: Int
    let license: String
    let safetyLevel: String
    let rotation: Int
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
    let urls: URLs
    var isFave: Bool {
        if isfavorite == 0 {
            return false
        } else {
            return true
        }
    }
    var link: String {
        "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case secret
        case server
        case farm
        case dateuploaded
        case isfavorite
        case license
        case safetyLevel = "safety_level"
        case rotation
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
        case urls
    }
    
    struct Owner: Decodable {
        let nsid: String
        let username: String
        let realname: String
        let location: String?
        let iconserver: String
        let iconfarm: Int
        
        enum CodingKeys: String, CodingKey {
            case nsid
            case username
            case realname
            case location
            case iconserver
            case iconfarm
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
    
    struct URLs: Decodable {
        let url: [JSONURL]
        
        struct JSONURL: Decodable {
            let type: String
            let content: String
            
            enum CodingKeys: String, CodingKey {
                case type
                case content = "_content"
            }
        }
    }
}

struct Photos: Decodable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total: Int
    let photo: [RecentPhoto]
    
    struct RecentPhoto: Decodable {
        let id: String
        let owner: String
        let secret: String
        let farm: Int
        let server: String
        let title: String
        let ownername: String
        let dateupload: Date
        let iconserver: String
        let iconfarm: Int
        var link: String {
            "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_b.jpg"
        }
        var profileImageLink: String {
            "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(owner).jpg"
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case owner
            case secret
            case farm
            case server
            case title
            case ownername
            case dateupload
            case iconserver
            case iconfarm
        }
    }
}


