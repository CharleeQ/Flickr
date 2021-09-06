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
// key not found thm_data
extension NetworkService {
    func getTagsHotList(period: Period = .day,
                        count: Int = 20,
                        completion: @escaping (Result<[TagsFlickrApi.HotTags.Tag], Error>) -> Void) {
        request(method: "flickr.tags.getHotList", parameters: [.count: count,
                                                               .period: period]) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    let json = try decoder.decode(TagsFlickrApi.self, from: data)
                    completion(.success(json.hottags.tag))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
