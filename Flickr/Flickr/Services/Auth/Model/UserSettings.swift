//
//  UserSettings.swift
//  Flickr
//
//  Created by Кирилл Какареко on 23.09.2021.
//

import Foundation

struct UserSettings {
    static let key = "authUser"
    static func save(_ value: AuthUser) {
         UserDefaults.standard.set(try? PropertyListEncoder().encode(value), forKey: key)
    }
    static func get() -> AuthUser! {
        var userData: AuthUser!
        if let data = UserDefaults.standard.value(forKey: key) as? Data {
            userData = try? PropertyListDecoder().decode(AuthUser.self, from: data)
            return userData
        } else {
            return userData
        }
    }
    static func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
