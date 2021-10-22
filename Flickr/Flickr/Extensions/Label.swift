//
//  Label.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.10.2021.
//

import UIKit

extension UILabel {
    func setDate(timestamp: String, format: String = "YYYY MMMM dd, hh:mm:ss") {
        if let time = Double(timestamp) {
            let date = Date(timeIntervalSince1970: time)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = .current
            self.text = dateFormatter.string(from: date)
            return
        }
        self.text = ""
    }
}
