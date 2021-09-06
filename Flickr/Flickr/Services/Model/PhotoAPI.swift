//
//  Photo.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import Foundation

struct PhotoFlickrApi: Decodable {
    let photo: Photo
    let stat: String
    
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
        
        struct Owner: Decodable {
            let nsid: String
            let username: String
            let realname: String
            let location: String
            let iconserver: String
            let iconfarm: Int
            let pathAlias: String
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
}

struct RecentFlickrApi: Decodable {
    let photos: Photos
    let stat: String
    
    struct Photos: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [Photo]
        
        struct Photo: Decodable {
            let id: String
            let owner: String
            let secret: String
            let server: String
            let title: String
        }
    }
}

struct DeletePhotoFlickrApi: Decodable {
    let stat: String
}
