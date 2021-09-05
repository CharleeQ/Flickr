//
//  Tags.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.09.2021.
//

import Foundation

enum Period: String {
    case day
    case week
}

extension NetworkService {
    func getTagsHotList(period: Period = .day,
                        count: Int = 20,
                        completion: @escaping (Result<String, Error>) -> Void) {
        request(method: "flickr.tags.getHotList", parameters: [.count: count,
                                                               .period: period]) { result in
            switch result {
            case .success(let data):
                completion(.success(data.base64EncodedString()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
