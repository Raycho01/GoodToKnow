//
//  NavBarViewController.swift
//  GoodToKnow
//
//  Created by Raycho Kostadinov on 29.01.24.
//

import Foundation
import UIKit

protocol TabBarIndexProtocol {
    var tabBarIndex: Int { get }
}

final class TabBarController: UITabBarController {
    
    let hotNewsViewModel = HotNewsViewModel(tabBarIndex: 1)
    let allNewsViewModel = AllNewsViewModel(tabBarIndex: 2)
    
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
        
        let hotNewsVC = NewsListViewController(viewModel: hotNewsViewModel)
        let hotNewsNav = UINavigationController(rootViewController: hotNewsVC)
        setup(vc: hotNewsNav, title: hotNewsViewModel.headerModel.title, systemImage: "flame")
        
        let settingsVC = SettingsViewController()
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        setup(vc: settingsNav, title: "Settings", systemImage: "gearshape")
        
        let allNewsVC = NewsListViewController(viewModel: allNewsViewModel)
        let allNewsNav = UINavigationController(rootViewController: allNewsVC)
        setup(vc: allNewsNav, title: allNewsViewModel.headerModel.title, systemImage: "book.pages")
        
        viewControllers = [homeNav, hotNewsNav, allNewsNav, settingsNav]
    }
    
    private func setupUI() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.MainColors.tabBarBackground
        setTabBarItemColors(appearance.stackedLayoutAppearance)
        setTabBarItemColors(appearance.inlineLayoutAppearance)
        setTabBarItemColors(appearance.compactInlineLayoutAppearance)
        
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance
    }
    
    private func setTabBarItemColors(_ itemAppearance: UITabBarItemAppearance) {
        itemAppearance.normal.iconColor = UIColor.MainColors.primaryText
        itemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.MainColors.primaryText as Any]
         
        itemAppearance.selected.iconColor = UIColor.MainColors.accentColor
        itemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.MainColors.accentColor as Any]
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
