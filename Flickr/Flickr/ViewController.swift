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
//                network.getProfile(nsid: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let profile):
//                        print("[!] Profile:")
//                        print(profile.firstName + " " + profile.lastName)
//                        print("ID: " + profile.id)
//                        guard let country = profile.country, let city = profile.city else { return }
//                        print("Location: " + country + ", " + city)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getTagsHotList(count: 5) { result in
//                    switch result {
//                    case .success(let hottags):
//                        print("[!] Tags:")
//                        hottags.forEach { tag in
//                            print("Tag: " + tag.content)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getRecentPhotos(extras: "geo") { result in
//                    switch result {
//                    case .success(let photos):
//                        print("[!][!] Recent photos:")
//                        photos.forEach { print($0) }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getPhotoInfo(photoID: "51416324487") { result in
//                    switch result {
//                    case .success(let photo):
//                        print("[!][!] Photo info:")
//                        print("ID photo: " + photo.id)
//                        print("Owner: " + photo.owner.username)
//                        print("Location: " + photo.owner.location)
//                        print("Title: " + photo.title.content)
//                        print("Description: " + photo.description.content)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getCommentsList(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let comments):
//                        print("[!][!] Comments:")
//                        comments.forEach { comment in
//                            print("Comment: " + comment.content)
//                            print("Author: " + comment.realname)
//                            print("Comment ID: " + comment.id)
//                            print("___________________________")
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.addComment(photoID: "51370339706", commentText: "Amazing") { result in
//                    switch result {
//                    case .success(let comment):
//                        print("[!] Add Comment:")
//                        print("Comment: \(comment.content)\nID: \(comment.id)\nAuthor: \(comment.realname)")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.deleteComment(photoID: "51370339706", commentID: "38053722-51370339706-72157719835319750") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Delete status: \(data)")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.addFavorite(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let status):
//                        print("[!] Add favorite status: \(status)")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getFavoriteList(userID: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let fave):
//                        print("[!] Favorites")
//                        fave.forEach { fave in
//                            print("ID photo: \(fave.id)\nTitle: \(fave.title)\n________")
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.removeFavorite(photoID: "51370339706") { result in
//                    switch result {
//                    case .success(let status):
//                        print("[!] Remove favorite status: \(status)")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getPhotos(userID: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let photos):
//                        print("[!] Get Photos")
//                        photos.forEach { photo in
//                            print("ID photo: " + photo.id)
//                            print("Title: " + photo.title)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.deletePhoto(photoID: "51421698278") { result in
//                    switch result {
//                    case .success(let status):
//                        print("[!] Photo delete status: \(status)")
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
                network.uploadPhoto(fileName: "16520596.jpeg", title: "Onboarding", description: "Test") { result in
                    switch result {
                    case .success(let data):
                        print("[!] Upload photo")
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                }
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
