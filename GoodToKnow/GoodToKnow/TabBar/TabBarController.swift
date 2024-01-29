//
//  NavBarViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 29.01.24.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupViewControllers()
        setupUI()
    }

    private func setupViewControllers() {
        
        let homeVC = UIViewController()
        setup(vc: homeVC, title: "Home", systemImage: "house")
        
        let hotNewsVC = HotNewsViewController(viewModel: HotNewsViewModel())
        setup(vc: hotNewsVC, title: "Hot News", systemImage: "flame")
        
        let settingsVC = UIViewController()
        setup(vc: settingsVC, title: "Settings", systemImage: "gearshape")
        
        let allNewsVC = UIViewController()
        setup(vc: allNewsVC, title: "All news", systemImage: "book.pages")
        
        viewControllers = [homeVC, hotNewsVC, allNewsVC, settingsVC]
    }
    
    private func setupUI() {
        
        tabBar.tintColor = UIColor.MainColors.accentColor
        tabBar.barTintColor = UIColor.MainColors.tabBarBackground
        tabBar.unselectedItemTintColor = .white
        
    }
    
    private func setup(vc: UIViewController, title: String, systemImage: String? = nil) {
        
        vc.tabBarItem.title = title
        if let image = systemImage {
            vc.tabBarItem.image = UIImage(systemName: image)
        }
    }
}