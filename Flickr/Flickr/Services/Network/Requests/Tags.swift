//
//  Tags.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getHotList(apiKey: String, period: Int? = nil, count: Int? = nil, completion: @escaping (Result<String, Error>) -> Void) {
        var params = ["api_key": apiKey]
        if period != nil { params["period"] = String(period!) }
        if count != nil { params["count"] = String(count!) }
        request(method: "flickr.tags.getHotList", parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
