//
//  SignUpLabel.swift
//  Flickr
//
//  Created by Кирилл Какареко on 17.09.2021.
//

import UIKit
import SafariServices

class SignUpLabel: UILabel {
    var delegate: UIViewController?
    
    func setup() {
        let fontSize: CGFloat = 14
        let textString = NSMutableAttributedString(string: "Don’t have an account? Sign up.",
                                                   attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .light),.foregroundColor: UIColor.secondaryLabel, .kern: 0.5])
        let attrbs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
            .attachment: URL(string: "https://identity.flickr.com/sign-up")!,
            .underlineStyle: 0,
            .underlineColor: UIColor.clear]
        textString.addAttributes(attrbs, range: NSRange(location: 23, length: 8))
        attributedText = textString
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showSignUp))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func showSignUp() {
        guard let characterCount = self.text?.count else { return }
        guard let url = self.attributedText?.attribute(.attachment, at: characterCount - 1, effectiveRange: nil) as? URL else { return } // characterCount - 1, because we want to get last index in self.text
        let signUpVC = SignUpViewController()
        signUpVC.url = url
        signUpVC.title = "Sign Up"
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeScreen))
        signUpVC.navigationItem.rightBarButtonItem = barButton
        let vc = UINavigationController(rootViewController: signUpVC)
        vc.modalPresentationStyle = .popover
        delegate?.show(vc, sender: nil)
        
    }
    
    @objc private func closeScreen() {
        delegate?.dismiss(animated: true, completion: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
