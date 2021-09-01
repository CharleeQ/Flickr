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
                let network = NetworkService()
                network.getProfile(apiKey: authData["api_key"] ?? "", nsid: authData["user_nsid"] ?? "") { result in
                    switch result {
                    case .success(let data):
                        print("[!] Profile:")
                        print(data)
                    case .failure(let error):
                        print(error)
                    }
                }
                network.getHotList(apiKey: authData["api_key"] ?? "") { result in
                    switch result {
                    case .success(let data):
                        print("[!] Tags:")
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
