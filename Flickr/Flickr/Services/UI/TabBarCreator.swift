//
//  TabBarCreator.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.10.2021.
//

import UIKit

class TabBarCreator {
    func configuration() -> UITabBarController {
        let tabBar = UITabBarController()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "HomeVCID"))
        let galleryNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "GalleryVCID"))
        let profileNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ProfileVCID"))
        
        tabBar.setViewControllers([homeNC,
                                 galleryNC,
                                 profileNC], animated: false)
        
        return tabBar
    }
}
