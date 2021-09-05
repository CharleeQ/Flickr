//
//  ViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AuthService().login(presenter: self) { result in
            switch result {
            case .success(let authData):
                print(authData)
                let network = NetworkService(accessToken: authData["oauth_token"] ?? "", tokenSecret: authData["oauth_token_secret"] ?? "")
                network.getProfile(nsid: "193759241%40N06") { result in
                    switch result {
                    case .success(let profile):
                        print("[!] Profile:")
                        print(profile.firstName + " " + profile.lastName)
                        print("ID: " + profile.id)
                        guard let country = profile.country, let city = profile.city else { return }
                        print("Location: " + country + ", " + city)
                    case .failure(let error):
                        print(error)
                    }
                }
//                network.getTagsHotList(count: 5) { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Tags:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getRecentPhotos(extras: "geo") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Recent:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getPhotoInfo(photoID: "51416324487") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Info:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getCommentsList(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Comments List:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.addComment(photoID: "51370339706", commentText: "Hello") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Add Comment:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.deleteComment(photoID: "51370339706", commentID: "38053722-51370339706-72157719765333219") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Delete comment:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.addFavorite(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Add favorite")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getFavoriteList(userID: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Favorites")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.removeFavorite(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Remove favorite")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getPhotos(userID: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Get Photos")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.deletePhoto(photoID: "51422206124") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Delete photo")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.uploadPhoto(fileName: "00_onboarding.png", image: UIImage(named: "00_onboarding")!, title: "Onboarding", description: "Test image") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Upload photo")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                not working upload
            case .failure(let error):
                print(error)
            }
            
        }
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
