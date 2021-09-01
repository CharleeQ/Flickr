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
        AuthService.shared.login(presenter: self) { result in
            switch result {
            case .success(let authData):
                print(authData)
                let network = NetworkService(accessToken: authData["oauth_token"] ?? "", tokenSecret: authData["oauth_token_secret"] ?? "")
//                network.getProfile(nsid: "193759241%40N06") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Profile:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getTagsHotList() { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Tags:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.getRecentPhotos(extras: "owner_name,last_update") { result in
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
//                network.getCommentsList(photoID: "51416324487") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Comments List:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//                network.addComment(photoID: "51416324487", commentText: "Hello") { result in
//                    switch result {
//                    case .success(let data):
//                        print("[!] Add Comment:")
//                        print(data)
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
                network.deleteComment(photoID: "51416324487", commentID: "193535940-51416324487-72157719771241642") { result in
                    switch result {
                    case .success(let data):
                        print("[!] Delete comment:")
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
