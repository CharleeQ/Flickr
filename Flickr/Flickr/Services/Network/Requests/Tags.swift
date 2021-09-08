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
                        completion: @escaping (Result<[Tag], Error>) -> Void) {
        request(method: "flickr.tags.getHotList", parameters: [.count: count,
                                                               .period: period]) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    print(String.init(data: data, encoding: .utf8)!)
                    
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

private struct TagsFlickrApi: Decodable {
    let stat: String
    let period: String
    let count: Int
    let hottags: HotTags
    
    struct HotTags: Decodable {
        let tag: [Tag]
    }
}
