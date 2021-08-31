//
//  NetworkService.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

class NetworkService {
    let accessToken: String
    
    init(access: String) {
        accessToken = access
    }
    
    func request(http: HTTPMethod = .GET, method: String, completion: (Result<String, Error>) -> Void) {
        
    }
}
