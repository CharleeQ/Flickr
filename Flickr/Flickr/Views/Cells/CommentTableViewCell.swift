//
//  CommentTableViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 21.10.2021.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateCommented: UILabel!
    
    func config(item: CommentPhoto) {
        // avatar image
        avatarImage.setPhoto(link: item.linkToAvatar)

        // content
        let nick = NSMutableAttributedString(string: item.nickname + " ", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)])
        let content = NSMutableAttributedString(string: item.content, attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .regular)])
        nick.append(content)
        commentLabel.attributedText = nick
        
        // date
    }
}
