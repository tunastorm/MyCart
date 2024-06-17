//
//  TabBarController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.tintColor = Resource.MyColor.orange
        tabBar.unselectedItemTintColor = Resource.MyColor.lightGray
        tabBar.layer.addBorder([.top], color: Resource.MyColor.lightGray, width: Resource.Border.width1)
        
        let searchCon = SearchViewController()
        
        let main = MainTableViewController()
        main.delegate = searchCon
        
        let setting = SettingViewController()
        setting.searchDelegate = searchCon
        setting.authDelegate = AuthViewController()
        
        let nav0 = UINavigationController(rootViewController: main)
        let nav1 = UINavigationController(rootViewController: setting)
        
        nav0.tabBarItem = UITabBarItem(title: Resource.Text.searchTabBar,
                                       image: Resource.SystemImage.magnifyingGlass, tag: 0)
        nav1.tabBarItem = UITabBarItem(title: Resource.Text.settingTabBar,
                                       image: Resource.SystemImage.person, tag: 1)
        
        // stroyboard 상에서 view controller seg설정하는 것과 동일
        setViewControllers([nav0, nav1], animated: true)
    }
}
