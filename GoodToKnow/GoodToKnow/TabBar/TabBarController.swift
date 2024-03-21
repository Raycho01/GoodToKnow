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
        
        let homeHeaderModel = NewsListHeaderViewModel(title: "Home", shouldShowSearch: false)
        let homeVC = HomeViewController(headerViewModel: homeHeaderModel)
        let homeNav = UINavigationController(rootViewController: homeVC)
        setup(vc: homeNav, title: "Home", systemImage: "house")
        
        let hotNewsHeaderModel = NewsListHeaderViewModel(title: "Hot News", shouldShowSearch: false)
        let hotNewsVC = NewsListViewController(viewModel: HotNewsViewModel(), headerViewModel: hotNewsHeaderModel)
        let hotNewsNav = UINavigationController(rootViewController: hotNewsVC)
        setup(vc: hotNewsNav, title: hotNewsHeaderModel.title, systemImage: "flame")
        
        let settingsVC = UIViewController()
        setup(vc: settingsVC, title: "Settings", systemImage: "gearshape")
        
        let allNewsHeaderModel = NewsListHeaderViewModel(title: "All News", shouldShowSearch: true)
        let allNewsVC = NewsListViewController(viewModel: AllNewsViewModel(), headerViewModel: allNewsHeaderModel)
        let allNewsNav = UINavigationController(rootViewController: allNewsVC)
        setup(vc: allNewsNav, title: allNewsHeaderModel.title, systemImage: "book.pages")
        
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
