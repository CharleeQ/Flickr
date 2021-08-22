//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import Foundation
import Alamofire

class AuthService {
    static let shared = AuthService()
    
    // MARK: - Parameters
    
    let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
    let consumerSecret = "f1938a9c14a1d472"
    let callback = "www.github.com"
    let nonce = "956r13465"
    let timestamp = "1305586162"
    let version = "1.0"
    let signatureMethod = "HMAC-SHA1"
    var signature: String {
        let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252F\(callback)%26oauth_consumer_key%3D\(consumerKey)%26oauth_nonce%3D\(nonce)%26oauth_signature_method%3D\(signatureMethod)%26oauth_timestamp%3D\(timestamp)%26oauth_version%3D\(version)"
        return string.hmac(key: "\(consumerSecret)&")
    }
    
    var requestToken: String?
}

//"https://www.flickr.com/services/oauth/request_token?oauth_callback=http://www.github.com&oauth_consumer_key=1877653cabad94b4cd42e56f49689e6c&oauth_nonce=956r13465&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=kDgmLbI4KS8KYmNv8OD1cR0ln74="
