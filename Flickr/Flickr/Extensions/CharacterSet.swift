//
//  CharacterSet.swift
//  Flickr
//
//  Created by Кирилл Какареко on 10.09.2021.
//

import Foundation

extension CharacterSet {
    public static var urlCharset: CharacterSet {
        get {
            return CharacterSet
                .urlHostAllowed
                .subtracting(CharacterSet(charactersIn: "=&"))
        }
    }
    
    public static var urlQueryWithPlusAllowed: CharacterSet {
        get {
            return CharacterSet.urlQueryAllowed.subtracting(CharacterSet(charactersIn: "+"))
        }
    }
}
