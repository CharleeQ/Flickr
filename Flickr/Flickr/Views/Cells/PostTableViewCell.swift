//
//  PostTableViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 29.09.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateUploadLabel: UILabel!
    
    var datas: Recent? {
        didSet {
            guard let datas = datas else { return }
            usernameLabel.text = "\(datas.fullname) (\(datas.username))"
            locationLabel.text = datas.location
            dateUploadLabel.text = datas.dateUpload
            postImage.image = datas.image
            avatarImage.image = datas.profileAvatar
            
            // description
            let text = NSMutableAttributedString(string: datas.username + " ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
            let description = NSMutableAttributedString(string: datas.description, attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
            text.append(description)
            descriptionLabel.attributedText = text
        }
    }
    
    func setup() {
        self.avatarImage.layer.cornerRadius = 16
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
