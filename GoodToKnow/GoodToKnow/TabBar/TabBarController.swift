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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        roundTopCorners()
    }

    private func setupViewControllers() {
        
        let homeVC = HomeViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        setup(vc: homeNav, title: "Home", systemImage: "house")
        
        let hotNewsVC = NewsListViewController(viewModel: HotNewsViewModel(), headerViewModel: HotNewsHeaderViewModel())
        let hotNewsNav = UINavigationController(rootViewController: hotNewsVC)
        setup(vc: hotNewsNav, title: "Hot News", systemImage: "flame")
        
        let settingsVC = UIViewController()
        setup(vc: settingsVC, title: "Settings", systemImage: "gearshape")
        
        let allNewsVC = NewsListViewController(viewModel: AllNewsViewModel(), headerViewModel: AllNewsHeaderViewModel())
        let allNewsNav = UINavigationController(rootViewController: allNewsVC)
        setup(vc: allNewsNav, title: "All news", systemImage: "book.pages")
        
        viewControllers = [homeNav, hotNewsNav, allNewsNav, settingsVC]
    }
    
    private func setupUI() {
        
        tabBar.tintColor = UIColor.MainColors.accentColor
        tabBar.backgroundColor = UIColor.MainColors.tabBarBackground
        tabBar.barTintColor = UIColor.MainColors.tabBarBackground
        tabBar.unselectedItemTintColor = .white
    }
    
    private func setup(vc: UIViewController, title: String, systemImage: String? = nil) {
        
        vc.tabBarItem.title = title
        if let image = systemImage {
            vc.tabBarItem.image = UIImage(systemName: image)
        }
    }
    
    private func roundTopCorners() {
        tabBar.roundCorners([.topLeft, .topRight])
    }
}
