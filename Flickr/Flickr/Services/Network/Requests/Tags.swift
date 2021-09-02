//
//  Tags.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

extension NetworkService {
    func getTagsHotList(period: String = "day",
                        count: Int = 20,
                        format: String = "json",
                        completion: @escaping (Result<String, Error>) -> Void) {
        let params = ["api_key": consumerKey,
                      "count": String(count),
                      "period": period,
                      "method": "flickr.tags.getHotList",
                      "format": format]
        request(parameters: params) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
