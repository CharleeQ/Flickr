//
//  PhotoCollectionViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 19.10.2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    
    func config(data: UsersPhoto) {
        photo.setPhoto(link: data.link)
    }
}
