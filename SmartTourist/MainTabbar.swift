//
//  MainTabbar.swift
//  SeeItLiveThailand
//
//  Created by Thirawat Phannet on 9/30/2559 BE.
//  Copyright © 2559 Thirawat Phannet. All rights reserved.
//

import UIKit
import LCTabBarController

class MainTabbar: LCTabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LCTabBarController Load")
        
        
        let sizeTabIcon = CGSize(width: 30, height: 30)
        let colorTabIcon = UIColor.gray
        let colorTabIconActive = UIColor.red
        
        // TabVC 1 //
        let tabVC1 = tabLists()
        tabVC1.view.backgroundColor = UIColor.white
        tabVC1.tabBarItem.badgeValue = "23"
        tabVC1.title = "Lists"
        tabVC1.tabBarItem.image = UIImage.fontAwesomeIconWithName(.ListAlt, textColor: colorTabIcon, size: sizeTabIcon)
        tabVC1.tabBarItem.selectedImage = UIImage.fontAwesomeIconWithName(.ListAlt, textColor: colorTabIconActive, size: sizeTabIcon)
        
        
        // TabVC 2 //
        let tabVC2 = tabFeeds()
        tabVC2.view.backgroundColor = UIColor.white
        tabVC2.tabBarItem.badgeValue = "78"
        tabVC2.title = "Feeds"
        tabVC2.tabBarItem.image = UIImage.fontAwesomeIconWithName(.VideoCamera, textColor: colorTabIcon, size: sizeTabIcon)
        tabVC2.tabBarItem.selectedImage = UIImage.fontAwesomeIconWithName(.VideoCamera, textColor: colorTabIconActive, size: sizeTabIcon)
        
        
        
        // TabVC 3 //
        let tabVC3 = tabNearMe()
        tabVC3.view.backgroundColor = UIColor.white
        tabVC3.title = "NearMe"
        tabVC3.tabBarItem.image = UIImage.fontAwesomeIconWithName(.Map, textColor: colorTabIcon, size: sizeTabIcon)
        tabVC3.tabBarItem.selectedImage = UIImage.fontAwesomeIconWithName(.Map, textColor: colorTabIconActive, size: sizeTabIcon)
        
        
        let navC1: UINavigationController = UINavigationController(rootViewController: tabVC1)
        let navC2: UINavigationController = UINavigationController(rootViewController: tabVC2)
        let navC3: UINavigationController = UINavigationController(rootViewController: tabVC3)
      

        self.tabBar.barTintColor = UIColor.white
        self.viewControllers = [navC1,navC2,navC3]

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
