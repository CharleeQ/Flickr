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
        request(method: "flickr.tags.getHotList",
                parameters: [.count: count,
                             .period: period],
                serializer: JSONSerializer<TagsFlickrApi>()) { result in
            completion(result.map { $0.hottags.tag })
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
