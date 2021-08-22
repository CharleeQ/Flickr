//
//  AuthService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    
    struct Constants {
        static let consumerKey = "1877653cabad94b4cd42e56f49689e6c"
        static let consumerSecret = "f1938a9c14a1d472"
    }
    
    var signature: String {
        let string = "GET&https%3A%2F%2Fwww.flickr.com%2Fservices%2Foauth%2Frequest_token&oauth_callback%3Dhttp%253A%252F%252Fwww.github.com%26oauth_consumer_key%3D1877653cabad94b4cd42e56f49689e6c%26oauth_nonce%3D956r13465%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1305586162%26oauth_version%3D1.0"
        
        return string.hmac(key: "f1938a9c14a1d472&")
    }
}

//"https://www.flickr.com/services/oauth/request_token?oauth_callback=http://www.github.com&oauth_consumer_key=1877653cabad94b4cd42e56f49689e6c&oauth_nonce=956r13465&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1305586162&oauth_version=1.0&oauth_signature=kDgmLbI4KS8KYmNv8OD1cR0ln74="
