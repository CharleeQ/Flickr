//
//  Recent.swift
//  Flickr
//
//  Created by Кирилл Какареко on 05.10.2021.
//

import UIKit

struct Recent: Equatable {
    var profileAvatar: UIImage = UIImage(named: "stockAvatar.png")!
    var username: String = "Unknown"
    var fullname: String = "Unknown user"
    var location: String = "No location"
    var image: UIImage = UIImage(systemName: "photo")!
    var description: String = ""
    var dateUpload: String = "2004 September 19 00:01:23"
}
