//
//  HomeViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var usernameDescriptionLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateUploadLabel: UILabel!
}

class HomeViewController: UIViewController {

    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.usernameLabel.text = "User (kirykakareka)"
        cell.locationLabel.text = "Hrodna, Belarus"
        cell.usernameDescriptionLabel.text = "kirykakareka"
        cell.descriptionLabel.text = "Delivery DHL"
        
        return cell
    }
    
    
}
