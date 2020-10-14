//
//  MainTabBarController.swift
//  Real Estate App
//
//  Created by Bochkarov Valentyn on 03/09/2020.
//  Copyright © 2020 Bochkarov Valentyn. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.862745098, green: 0.1843137255, blue: 0.1803921569, alpha: 1)
    
    
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-Medium", size: 10) ?? UIFont.systemFontSize], for: .normal)
        let exploreVC = ExploreViewController()
        let savedVC = SavedViewController()
        let alertsVC = AlertsViewController()
        let profileVC = ProfileViewController()
        
        let exploreImage = UIImage(imageLiteralResourceName: "Explore")
        let savedImage = UIImage(imageLiteralResourceName: "Saved")
        let alertsImage = UIImage(imageLiteralResourceName: "Alerts")
        let profileImage = UIImage(imageLiteralResourceName: "Profile")
        
        viewControllers = [
     generateNavigationController(rootViewController: exploreVC, title: "Explore", image: exploreImage),
     generateNavigationController(rootViewController: savedVC, title: "Saved", image: savedImage),
     generateNavigationController(rootViewController: alertsVC, title: "Alerts", image: alertsImage),
     generateNavigationController(rootViewController: profileVC, title: "Profile", image: profileImage)
        ]
    }

    
    private func generateNavigationController(rootViewController: UIViewController, title: String,
                                              image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
}

