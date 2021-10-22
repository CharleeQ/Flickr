//
//  FavoriteButton.swift
//  Flickr
//
//  Created by Кирилл Какареко on 22.10.2021.
//

import UIKit

class FavoriteButton: UIButton {
    
    var isFavorite = false
    
    func changeStatus() {
        isFavorite = !isFavorite
        if isFavorite {
            self.setImage(UIImage(named: "Save.fill"), for: .normal)
        } else {
            self.setImage(UIImage(named: "Save"), for: .normal)
        }
    }
}
