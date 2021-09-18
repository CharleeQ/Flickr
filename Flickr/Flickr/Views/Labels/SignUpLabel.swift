//
//  SignUpLabel.swift
//  Flickr
//
//  Created by Кирилл Какареко on 17.09.2021.
//

import UIKit

class SignUpLabel: UILabel {
    func setup() {
        let fontSize: CGFloat = 14
        let textString = NSMutableAttributedString(string: "Don’t have an account? Sign up.",
                                                   attributes: [.font: UIFont.systemFont(ofSize: fontSize, weight: .light),.foregroundColor: UIColor.secondaryLabel, .kern: 0.5])
        let attrbs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: fontSize, weight: .semibold),
            .link: URL(string: "https://identity.flickr.com/sign-up")!,
            .underlineStyle: 0,
            .underlineColor: UIColor.clear]
        textString.addAttributes(attrbs, range: NSRange(location: 23, length: 7))
        attributedText = textString
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
