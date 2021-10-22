//
//  Serializer.swift
//  Flickr
//
//  Created by Кирилл Какареко on 08.09.2021.
//

import Foundation
import CoreMedia

enum ErrorParsing: Error {
    case dateFormatting
}

protocol SerializerProtocol {
    associatedtype R
    func parse(data: Data) throws -> R
}

struct JSONSerializer<R>: SerializerProtocol where R: Decodable {
    func parse(data: Data) throws -> R {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let value = try container.decode(String.self)
            
            if let doubleValue = Double(value) {
                return Date(timeIntervalSince1970: doubleValue)
            } else {
                throw ErrorParsing.dateFormatting
            }
        })
        print(String(data: data, encoding: .utf8)!)
        return try decoder.decode(R.self, from: data)
    }
}

struct VoidSerializer: SerializerProtocol {
    func parse(data: Data) throws -> Void {
        return ()
    }
}
