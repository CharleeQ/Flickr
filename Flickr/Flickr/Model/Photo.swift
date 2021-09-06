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
}

struct Photo: Decodable {
    
}

