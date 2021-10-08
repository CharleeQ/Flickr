//
//  SpinnerTableViewCell.swift
//  Flickr
//
//  Created by Кирилл Какареко on 07.10.2021.
//

import UIKit

class SpinnerTableViewCell: UITableViewCell {
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        spinner.startAnimating()
    }
    
    override func prepareForReuse() {
        spinner.startAnimating()
    }
    
}
