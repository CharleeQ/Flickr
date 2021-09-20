//
//  ViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var logotype: LogotypeLabel!
    @IBOutlet weak var signUpLabel: SignUpLabel!
    @IBOutlet weak var loginButton: LoginWithFlickrButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSignUp))
        signUpLabel.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func login(_ sender: Any) {
        AuthService().login(presenter: self) { result in
            switch result {
            case .success(let data):
                print("login \(data)")
                DispatchQueue.main.async {
                    self.showAlert(title: "Welcome!",
                                   message: "Hello, \(data["fullname"]?.removingPercentEncoding ?? "User")",
                                   buttonTitle: "Start")
                }
            case .failure(_):
                self.showAlert(title: "Login failed",
                               message: "Please try again.",
                               buttonTitle: "Sure")
            }
        }
    }
    
    @objc private func showSignUp() {
        guard let characterCount = signUpLabel.text?.count else { return }
        if let url = signUpLabel.attributedText?.attribute(.attachment, at: characterCount - 2 , effectiveRange: nil) as? URL {
            let safariVC = SFSafariViewController(url: url)
            self.show(safariVC, sender: nil)
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
