//
//  LoginButton.swift
//  Flickr
//
//  Created by Кирилл Какареко on 17.09.2021.
//

import UIKit

class LoginWithFlickrButton: UIButton {
    func setup() {
        backgroundColor = UIColor.superPink
        layer.cornerRadius = 6
        clipsToBounds = true
        let titleString = NSMutableAttributedString(string: "Log in with flickr.com",
                                                    attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold)])
        titleString.addAttribute(.font,
                                 value: UIFont.systemFont(ofSize: 18, weight: .bold),
                                 range: NSRange(location: 12, length: 10))
        setAttributedTitle(titleString, for: .normal)
    }
    
    override var isHighlighted: Bool {
        didSet {
            guard let color = backgroundColor else { return }
            
            layer.removeAllAnimations()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .allowUserInteraction], animations: {
                self.backgroundColor = color.withAlphaComponent(self.isHighlighted ? 0.3 : 1)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
}
