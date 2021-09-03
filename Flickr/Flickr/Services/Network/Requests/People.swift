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

/* 1 1 public photos
 2 private photos visible to friends
 3 private photos visible to family
 4 private photos visible to friends & family
 5 completely private photos */

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
                   minUploadDate: Date? = nil,
                   maxUploadDate: Date? = nil,
                   minTakenDate: Date? = nil,
                   maxTakenDate: Date? = nil,
                   contentType: ContentType = .forAll,
                   privacyFilter: PrivacyFilter = .publicPhotos,
                   extras: String = "",
                   perPage: Int = 100,
                   page: Int = 1,
                   completion: @escaping (Result<String, Error>) -> Void) {
        
        requestWithOAuth(method: "flickr.people.getPhotos", parameters: [.user_id: userID,
                                                                         .safe_search: safeSearch.rawValue,
                                                                         /*.min_upload_date: minUploadDate,
                                                                         .max_upload_date: maxUploadDate,
                                                                         .min_taken_date: minTakenDate,
                                                                         .max_taken_date: maxTakenDate,*/
                                                                         .content_type: contentType.rawValue,
                                                                         .privacy_filter: privacyFilter.rawValue,
                                                                         .extras: extras,
                                                                         .per_page: perPage,
                                                                         .page: page]) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
