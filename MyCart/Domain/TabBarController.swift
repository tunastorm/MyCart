//
//  TabBarController.swift
//  MyCart
//
//  Created by 유철원 on 6/15/24.
//

import UIKit

class TabBarController: UITabBarController {
        
    private let mainNavi = UINavigationController(rootViewController: MainViewController())
    private let likedItemNavi = UINavigationController(rootViewController: LikedItemViewController())
    private let settingNavi = UINavigationController(rootViewController: SettingViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        tabBar.tintColor = Resource.MyColor.orange
        tabBar.unselectedItemTintColor = Resource.MyColor.lightGray
        tabBar.layer.addBorder([.top], color: Resource.MyColor.lightGray, width: Resource.Border.width1)
        
        mainNavi.tabBarItem = UITabBarItem(title: Resource.Text.searchTabBar,
                                       image: Resource.SystemImage.magnifyingGlass, tag: 0)
        likedItemNavi.tabBarItem = UITabBarItem(title: Resource.Text.likedItemTabBar,
                                                image: Resource.NamedImage.likeSelected, tag: 1)
        settingNavi.tabBarItem = UITabBarItem(title: Resource.Text.settingTabBar,
                                       image: Resource.SystemImage.person, tag: 2)

        setViewControllers([mainNavi, likedItemNavi, settingNavi], animated: true)
    }
}
