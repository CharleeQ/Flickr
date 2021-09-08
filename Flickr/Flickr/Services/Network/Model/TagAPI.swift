//
//  Tag.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import Foundation

struct Tag: Decodable {
    let content: String
    let thmData: ThmData
    
    enum CodingKeys: String, CodingKey {
        case content = "_content"
        case thmData
    }
    
    struct ThmData: Decodable {
        let photos: PhotosTag
        
        struct PhotosTag: Decodable {
            let photo: [PhotoTag]
            
            struct PhotoTag: Decodable {
                let id: String
                let secret: String
                let server: String
                let farm: Int
                let owner: String
                let username: String?
                let title: String
                let ispublic: Int
                let isfriend: Int
                let isfamily: Int
            }
        }
    }
}
