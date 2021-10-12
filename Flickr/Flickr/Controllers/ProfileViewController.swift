//
//  ProfileViewController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 14.09.2021.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Storyboard elements
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var profileAvatar: UIImageView!
    @IBOutlet weak var logOutButton: UIButton!
    
    // MARK: - Global properties
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: - Configuration
        // logo image in navbar
        let logo = UIImage(named: "logoSmall.png")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        // button logout bgcolor
        logOutButton.backgroundColor = UIColor.shineBlue
        
        profileInfo()
    }
    
    private func profileInfo() {
        network.getProfile(nsid: UserSettings.get().nsid) { result in
            switch result {
            case .success(let profileInfo):
                self.fullnameLabel.text = "\(profileInfo.firstName) \(profileInfo.lastName)"
                self.descriptionLabel.text = profileInfo.profileDescription
                
                self.network.getHumanInfo(userID: profileInfo.id) { result in
                    switch result {
                    case .success(let info):
                        let avaStaticURL: String = "https://farm\(info.iconfarm).staticflickr.com/\(info.iconserver)/buddyicons/\(info.id)_l.jpg"
                        guard let url = URL(string: avaStaticURL) else { return }
                        guard let data = try? Data(contentsOf: url) else { return }
                        if let image = UIImage(data: data) {
                            self.profileAvatar.image = image
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func logOutTapped(_ sender: UIButton) {
    }
}
