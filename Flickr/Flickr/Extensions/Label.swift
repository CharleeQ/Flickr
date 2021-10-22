//
//  Label.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.10.2021.
//

import UIKit

extension UILabel {
    func setDate(timestamp: Date, format: String = "YYYY MMMM dd, hh:mm:ss") {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = .current
        self.text = dateFormatter.string(from: timestamp)
        return
    }
}
