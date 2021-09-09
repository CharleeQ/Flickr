//
//  Profile.swift
//  Flickr
//
//  Created by Кирилл Какареко on 31.08.2021.
//

import Foundation

extension NetworkService {
    func getProfile(nsid: String,
                    completion: @escaping (Result<Profile, Error>) -> Void) {
        request(method: "flickr.profile.getProfile",
                parameters: [.user_id: nsid],
                serializer: JSONSerializer<ProfileFlickrApi>()) { result in
            completion(result.map { $0.profile })
        }
    }
}

private struct ProfileFlickrApi: Decodable {
    let stat: String
    let profile: Profile
}
