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
        signUpLabel.delegate = self
    }
    
    @IBAction func login(_ sender: Any) {
        AuthService().login(presenter: self) { result in
            switch result {
            case .success(_):
                UIApplication.shared.windows.first?.rootViewController = RootCoordinator().checkLogin()
            case .failure(_):
                self.showAlert(title: "Login failed",
                               message: "Please try again.",
                               buttonTitle: "Sure")
            }
        }
    }
    
    private func showAlert(title: String, message: String, buttonTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionCancel = UIAlertAction(title: buttonTitle, style: .cancel, handler: nil)
        alert.addAction(actionCancel);
        self.present(alert, animated: true, completion: nil)
    }
}

extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
}
