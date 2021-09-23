//
//  AuthUser.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.09.2021.
//

import Foundation

class AuthUser: NSObject, NSCoding {
    var token: String
    var tokenSecret: String
    var nsid: String
    var username: String
    var fullname: String
    
    init(token: String, tokenSecret: String, nsid: String, username: String, fullname: String) {
        self.token = token
        self.tokenSecret = tokenSecret
        self.nsid = nsid
        self.username = username
        self.fullname = fullname
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(token, forKey: "token")
        coder.encode(tokenSecret, forKey: "tokenSecret")
        coder.encode(nsid, forKey: "nsid")
        coder.encode(username, forKey: "username")
        coder.encode(fullname, forKey: "fullname")
    }
    
    required init?(coder: NSCoder) {
        token = coder.decodeObject(forKey: "token") as? String ?? ""
        tokenSecret = coder.decodeObject(forKey: "tokenSecret") as? String ?? ""
        nsid = coder.decodeObject(forKey: "nsid") as? String ?? ""
        username = coder.decodeObject(forKey: "username") as? String ?? ""
        fullname = coder.decodeObject(forKey: "fullname") as? String ?? ""
    }
}
