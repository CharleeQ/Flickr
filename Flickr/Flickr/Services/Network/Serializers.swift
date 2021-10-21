//
//  Serializer.swift
//  Flickr
//
//  Created by Кирилл Какареко on 08.09.2021.
//

import Foundation

protocol SerializerProtocol {
    associatedtype R
    func parse(data: Data) throws -> R
}

struct JSONSerializer<R>: SerializerProtocol where R: Decodable {
    func parse(data: Data) throws -> R {
        let decoder = JSONDecoder()
        print(String(data: data, encoding: .utf8)!)
        return try decoder.decode(R.self, from: data)
    }
}

struct VoidSerializer: SerializerProtocol {
    func parse(data: Data) throws -> Void {
        return ()
    }
}
