//
//  LoginButton.swift
//  Flickr
//
//  Created by Кирилл Какареко on 17.09.2021.
//

import UIKit

class LoginWithFlickrButton: UIButton {
    func setup() {
        backgroundColor = .clear
        layer.backgroundColor = UIColor.superPink.cgColor
        layer.cornerRadius = 6
        clipsToBounds = true
        let titleString = NSMutableAttributedString(string: "Log in with flickr.com",
                                                    attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .semibold)])
        titleString.addAttribute(.font,
                                 value: UIFont.systemFont(ofSize: 24, weight: .bold),
                                 range: NSRange(location: 12, length: 10))
        setAttributedTitle(titleString, for: .normal)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
