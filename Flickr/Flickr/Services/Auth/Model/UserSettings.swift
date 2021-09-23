//
//  UserSettings.swift
//  Flickr
//
//  Created by Кирилл Какареко on 23.09.2021.
//

import Foundation

class UserSettings {
    static var authUser: AuthUser! {
        get {
            guard let data = UserDefaults.standard.object(forKey: "authUser") as? Data,
                  let model = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? AuthUser else { return nil }
            return model
        }
        set {
            let defaults = UserDefaults.standard
            guard let value = newValue else { return }
            if let data = try? NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false) {
                defaults.set(data, forKey: "authUser")
            }
        }
    }
}
