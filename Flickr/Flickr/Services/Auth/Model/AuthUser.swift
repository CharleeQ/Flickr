//
//  AuthUser.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.09.2021.
//

import Foundation

struct AuthUser: Codable {
    let token: String
    let tokenSecret: String
    let nsid: String
    let username: String
    let fullname: String
    
    init(token: String, tokenSecret: String, nsid: String, username: String, fullname: String) {
        self.token = token
        self.tokenSecret = tokenSecret
        self.nsid = nsid
        self.username = username
        self.fullname = fullname
    }
}
