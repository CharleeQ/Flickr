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
