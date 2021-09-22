//
//  Logotype.swift
//  Flickr
//
//  Created by Кирилл Какареко on 17.09.2021.
//

import UIKit

class LogotypeLabel: UILabel {
    func setup() {
        let textString = NSMutableAttributedString(string: "Flickr",
                                                   attributes: [.foregroundColor: UIColor.deepBlue])
        textString.addAttribute(.foregroundColor,
                                value: UIColor.shineCoral,
                                range: NSRange(location: 3, length: 3))
        
        attributedText = textString
        let fontSize: CGFloat = 64
        let systemFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        let roundedFont: UIFont
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            roundedFont = UIFont(descriptor: descriptor, size: fontSize)
        } else {
            roundedFont = systemFont
        }
        font = roundedFont
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}
