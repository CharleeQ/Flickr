//
//  User.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.09.2021.
//

import Foundation

struct ProfileFlickrApi: Decodable {
    let stat: String
    let profile: Profile
}

struct Profile: Decodable {
    let id: String
    let firstName: String
    let lastName: String
    let profileDescription: String
    let city: String?
    let country: String?
}
