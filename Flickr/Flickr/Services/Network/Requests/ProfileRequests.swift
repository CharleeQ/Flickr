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
            switch result {
            case .success(let json):
                completion(.success(json.profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct ProfileFlickrApi: Decodable {
    let stat: String
    let profile: Profile
}
