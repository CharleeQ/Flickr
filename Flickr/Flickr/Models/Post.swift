//
//  Post.swift
//  Flickr
//
//  Created by Кирилл Какареко on 24.10.2021.
//

import Foundation

struct Post: Equatable {
    let link: String
    let date: Date
    let title: String
    let description: String
    let isFavorite: Bool
}
