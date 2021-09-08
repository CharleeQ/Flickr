//
//  FaveAPI.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.09.2021.
//

import Foundation

struct FaveFlickrApi: Decodable {
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

struct AddFaveFlickrApi: Decodable {
    let stat: String
}

struct RemoveFaveFlickrApi: Decodable {
    let stat: String
}
