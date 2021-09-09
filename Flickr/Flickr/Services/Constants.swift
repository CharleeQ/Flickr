//
//  Constants.swift
//  Flickr
//
//  Created by Кирилл Какареко on 02.09.2021.
//

import Foundation

struct Constants {
    let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
    let consumerSecret = "f1938a9c14a1d472"
    let version = "1.0"
    let signatureMethod = "HMAC-SHA1"
    let callbackScheme = "kiryl"
    var nonce = UUID().uuidString
    var timestamp = String(Date().timeIntervalSince1970)
    let perms = "delete"
    
    let urlCharset = CharacterSet.urlHostAllowed.subtracting(CharacterSet(charactersIn: "=&"))
    
}
