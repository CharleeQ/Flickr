//
//  TabBarCreator.swift
//  Flickr
//
//  Created by Кирилл Какареко on 06.10.2021.
//

import UIKit

class RootCoordinator {
    func checkLogin() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if UserSettings.get() == nil {
            return storyboard.instantiateViewController(withIdentifier: "LoginVC")
        } else {
            let tabBar = UITabBarController()
            let homeNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "HomeVCID"))
            let galleryNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "GalleryVCID"))
            let profileNC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "ProfileVCID"))
            
            tabBar.setViewControllers([homeNC,
                                     galleryNC,
                                     profileNC], animated: false)
            return tabBar
        }
    }
}
