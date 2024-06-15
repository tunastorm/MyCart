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
        
        let search = SearchViewController()
        let setting = SettingViewController()
        
        let nav1 = UINavigationController(rootViewController: search)
        let nav2 = UINavigationController(rootViewController: setting)
        
        nav1.tabBarItem = UITabBarItem(title: Resource.Text.searchTabBar,
                                       image: Resource.SystemImage.magnifyingGlass, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: Resource.Text.settingTabBar, 
                                       image: Resource.SystemImage.person, tag: 1)
        
        // stroyboard 상에서 view controller seg설정하는 것과 동일
        setViewControllers([nav1, nav2], animated: true)
        
//        tabBarController?.tabBar.items = [nav1.tabBarItem, nav2.tabBarItem, nav3.tabBarItem]
    }
}
