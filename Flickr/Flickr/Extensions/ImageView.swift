//
//  ImageView.swift
//  Flickr
//
//  Created by Кирилл Какареко on 13.10.2021.
//

import UIKit

extension UIImageView {
    func setPhoto(link: String) {
        guard let url = URL(string: link),
              let data = try? Data(contentsOf: url)
        else {
            self.image = nil
            return
        }
        self.image = UIImage(data: data)
    }
}
