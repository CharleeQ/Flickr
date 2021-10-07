//
//  SpinnerTableViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 07.10.2021.
//

import UIKit

class SpinnerTableViewCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func config() {
        spinner.startAnimating()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
}
