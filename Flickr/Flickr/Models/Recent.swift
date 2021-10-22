//
//  Recent.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.10.2021.
//

import UIKit

struct Recent: Equatable {
    let profileAvatarLink: String
    let username: String
    let fullname: String
    let location: String
    let link: String
    let description: String
    let dateUpload: String
    let id: String
    let title: String
    var isFavorite: Bool
}
