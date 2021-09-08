//
//  People.swift
//  Flickr
//
//  Created by Кирилл Какареко on 02.09.2021.
//

import Foundation

enum SafeSearch: Int {
    case forSafe = 1
    case forModerate = 2
    case forRestricted = 3
}

enum ContentType: Int {
    case forPhotosOnly = 1
    case forOtherOnly = 2
    case forScreenshotsOnly = 3
    case forPhotosAndScreenshots = 4
    case forPhotosAndOther = 5
    case forScreenshotsAndOther = 6
    case forAll = 7
}

enum PrivacyFilter: Int {
    case publicPhotos = 1
    case privatePhotosVisibleToFriends = 2
    case privatePhotosVisibleToFamily = 3
    case privatePhotosVisibleToFriendsAndFamily = 4
    case completelyPrivatePhotos = 5
}

extension NetworkService {
    func getPhotos(userID: String,
                   safeSearch: SafeSearch = .forSafe,
                   contentType: ContentType = .forAll,
                   privacyFilter: PrivacyFilter = .publicPhotos,
                   extras: String = "",
                   perPage: Int = 100,
                   page: Int = 1,
                   completion: @escaping (Result<[PeoplePhotosFlickrApi.Photos.Photo], Error>) -> Void) {
        
        requestWithOAuth(method: "flickr.people.getPhotos", parameters: [.user_id: userID,
                                                                         .safe_search: safeSearch.rawValue,
                                                                         .content_type: contentType.rawValue,
                                                                         .privacy_filter: privacyFilter.rawValue,
                                                                         .extras: extras,
                                                                         .per_page: perPage,
                                                                         .page: page]) { result in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let json = try decoder.decode(PeoplePhotosFlickrApi.self, from: data)
                    completion(.success(json.photos.photo))
                } catch let error {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
