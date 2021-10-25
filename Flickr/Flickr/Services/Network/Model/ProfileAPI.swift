//
//  User.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import Foundation

struct Profile: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let profileDescription: String
    let city: String?
    let country: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case profileDescription = "profile_description"
        case city
        case country
    }
}

