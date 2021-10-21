//
//  PostDetailTableViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 21.10.2021.
//

import UIKit

class PostDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UILabel!
    @IBOutlet weak var dateUpload: UILabel!
    
    func config(item: Recent) {
        postImage.setPhoto(link: item.link)
        postDescription.text = item.description
        dateUpload.text = item.dateUpload
        postTitle.text = item.title
    }
}
