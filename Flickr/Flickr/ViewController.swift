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
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
            return view.window!
    }
}
