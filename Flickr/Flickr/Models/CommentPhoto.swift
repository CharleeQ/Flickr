//
//  CommentPhoto.swift
//  Flickr
//
//  Created by Кирилл Какареко on 21.10.2021.
//

import Foundation

struct CommentPhoto: Equatable {
    let linkToAvatar: String
    let nickname: String
    let content: String
    let dateCommented: Date
}
