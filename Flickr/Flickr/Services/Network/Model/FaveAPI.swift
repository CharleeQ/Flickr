//
//  FaveAPI.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.09.2021.
//

import Foundation

struct FavoritePhoto: Decodable {
    let id: String
    let owner: String
    let secret: String
    let server: String
    let title: String
}
