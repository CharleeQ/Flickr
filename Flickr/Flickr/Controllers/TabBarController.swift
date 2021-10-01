//
//  TabBarController.swift
//  Flickr
//
//  Created by Кирилл Какареко on 01.10.2021.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "HomeVCID"))
        homeNC.title = "Home"
        let galleryNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "GalleryVCID"))
        galleryNC.title = "Gallery"
        let profileNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ProfileVCID"))
        profileNC.title = "Profile"

        self.setViewControllers([homeNC,
                                 galleryNC,
                                 profileNC], animated: false)
        
        // Change image in TabBar
        guard let items = self.tabBar.items else { return }
        let images = ["house", "star", "person"]
        
        for i in 0...2 {
            items[i].image = UIImage(systemName: images[i])
        }
    }

}
