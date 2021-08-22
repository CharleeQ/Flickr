//
//  ViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("[1] Signing Requests")
        print(AuthService.shared.signature)
        
        print("[2] Request Token")
        AF.request("https://www.flickr.com/services/oauth/request_token?oauth_callback=http://\(AuthService.shared.callback)&oauth_consumer_key=\(AuthService.shared.consumerKey)&oauth_nonce=\(AuthService.shared.nonce)&oauth_signature_method=\(AuthService.shared.signatureMethod)&oauth_timestamp=\(AuthService.shared.timestamp)&oauth_version=\(AuthService.shared.version)&oauth_signature=\(AuthService.shared.signature)").responseString { response in
            switch response.result {
            case .success(let data):
                AuthService.shared.requestToken = data.components(separatedBy: "&oauth_token=").last?.components(separatedBy: "&oauth_token_secret").first
                AuthService.shared.tokenSecret = data.components(separatedBy: "&oauth_token_secret=").last
                print(AuthService.shared.tokenSecret!)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

