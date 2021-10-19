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
    func getHumanInfo(userID: String, completion: @escaping (Result<Person, Error>) -> Void) {
        let params: [NetworkParameters: Any] = [.user_id: userID]
        request(method: "flickr.people.getInfo", parameters: params, serializer: JSONSerializer<UserInfoFlickrApi>()) { result in
            switch result {
            case .success(let personInfo):
                completion(.success(personInfo.person))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func getPhotos(userID: String,
                   extras: String?,
                   perPage: Int = 100,
                   page: Int = 1,
                   completion: @escaping (Result<[UsersPhoto], Error>) -> Void) {
        var params: [NetworkParameters: Any] = [.user_id: userID,
                                                .per_page: perPage,
                                                .page: page,
                                                .privacy_filter: "1"]
        if let extras = extras { params[.extras] = extras }
        
        requestWithOAuth(http: .POST,
                         method: "flickr.people.getPhotos",
                         parameters: params,
                         serializer: JSONSerializer<PeoplePhotosFlickrApi>()) { result in
            switch result {
            case .success(let json):
                completion(.success(json.photos.photo))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private struct PeoplePhotosFlickrApi: Decodable {
    let photos: Photos
    let stat: String
    
    struct Photos: Decodable {
        let page: Int
        let pages: Int
        let perpage: Int
        let total: Int
        let photo: [UsersPhoto]
    }
}

private struct UserInfoFlickrApi: Decodable {
    let person: Person
    let stat: String
}
