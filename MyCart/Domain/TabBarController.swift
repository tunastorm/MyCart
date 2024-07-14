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
        
        let mainNavi = UINavigationController(rootViewController: MainViewController())
        let likedItemNavi = UINavigationController(rootViewController: LikedItemViewController())
        let settingNavi = UINavigationController(rootViewController: SettingViewController())
      
        mainNavi.tabBarItem = UITabBarItem(title: Resource.Text.searchTabBar,
                                       image: Resource.SystemImage.magnifyingGlass, tag: 0)
        likedItemNavi.tabBarItem = UITabBarItem(title: Resource.Text.likedItemTabBar,
                                                image: Resource.NamedImage.likeSelected.withRenderingMode(.alwaysTemplate), tag: 1)
        settingNavi.tabBarItem = UITabBarItem(title: Resource.Text.settingTabBar,
                                       image: Resource.SystemImage.person, tag: 2)

        setViewControllers([mainNavi, likedItemNavi, settingNavi], animated: true)
    }
}
