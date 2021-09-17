//
//  ViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logotype: LogotypeLabel! 
    @IBOutlet weak var signUpLabel: SignUpLabel!
    @IBOutlet weak var loginButton: LoginWithFlickrButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
