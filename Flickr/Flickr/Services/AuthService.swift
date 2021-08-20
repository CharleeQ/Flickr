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
        static let key = "1877653cabad94b4cd42e56f49689e6c"
        static let secretKey = "f1938a9c14a1d472"
    }
    
    public var signWithURL: URL? {
        let base = "https://www.flickr.com/services/oauth/request_token"
        let requestURL = "https://www.github.com/CharleeQ"
        let string = "\(base)?oauth_nonce=89601180&oauth_timestamp=1305583298&oauth_consumer_key=\(Constants.key)&oauth_signature_method=HMAC-SHA1&oauth_version=2.0&oauth_callback=\(requestURL)"
        
        return URL(string: string)
    }
}
