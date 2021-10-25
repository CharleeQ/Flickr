//
//  ImageView.swift
//  Flickr
//
//  Created by Кирилл Какареко on 13.10.2021.
//

import UIKit

extension UIImageView {
    func setPhoto(link: String) {
        DispatchQueue(label: "Set photo").async {
            guard let url = URL(string: link),
                  let data = try? Data(contentsOf: url)
            else {
                DispatchQueue.main.async {
                    self.image = nil
                }
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            
        }
    }
}
