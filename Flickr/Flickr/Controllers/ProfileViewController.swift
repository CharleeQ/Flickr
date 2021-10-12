//
//  ProfileViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Configuration
        // logo image in navbar
        let logo = UIImage(named: "logoSmall.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView

    }
}
