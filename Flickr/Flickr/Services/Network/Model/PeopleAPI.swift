//
//  PeopleAPI.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.09.2021.
//

import Foundation

struct UsersPhoto: Decodable, Equatable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
    var link: String {
        "https://live.staticflickr.com/\(server)/\(id)_\(secret).jpg"
    }
}

struct Person: Decodable {
    let id: String
    let iconserver: String
    let iconfarm: Int
    var link: String {
        "https://farm\(iconfarm).staticflickr.com/\(iconserver)/buddyicons/\(id)_l.jpg"
    }
}
