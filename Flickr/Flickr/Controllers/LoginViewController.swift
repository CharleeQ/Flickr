//
//  ViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 20.08.2021.
//

import UIKit
import AuthenticationServices
import WebKit

class LoginViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var logotype: LogotypeLabel!
    @IBOutlet weak var signUpLabel: SignUpLabel!
    @IBOutlet weak var loginButton: LoginWithFlickrButton!
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func showSignUp(url: URL) {
        let myRequest = URLRequest(url: url)
        webView.load(myRequest)
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
