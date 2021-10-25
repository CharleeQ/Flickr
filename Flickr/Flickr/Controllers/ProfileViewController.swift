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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Global properties
    private let network = NetworkService(accessToken: UserSettings.get().token,
                                         tokenSecret: UserSettings.get().tokenSecret)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProfileInfo()
    }
    
    private func loadProfileInfo() {
        network.getProfile(nsid: UserSettings.get().nsid) { result in
            switch result {
            case .success(let profileInfo):
                self.network.getHumanInfo(userID: profileInfo.id) { result in
                    switch result {
                    case .success(let info):
                        self.fullnameLabel.text = "\(profileInfo.firstName) \(profileInfo.lastName)"
                        self.descriptionLabel.text = profileInfo.profileDescription
                        self.fullnameLabel.backgroundColor = .systemBackground
                        self.descriptionLabel.backgroundColor = .systemBackground
                        self.spinner.stopAnimating()
                        self.profileAvatar.setPhoto(link: info.link)
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
        let alert = UIAlertController(title: "Log Out", message: "Are you sure?", preferredStyle: .actionSheet)
        let removeAction = UIAlertAction(title: "Sure", style: .destructive) { action in
            UserSettings.remove()
            UIApplication.shared.windows.first?.rootViewController = RootCoordinator().checkLogin()
        }
        alert.addAction(removeAction)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
