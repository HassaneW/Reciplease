//
//  HomeTabBarController.swift
//  Reciplease_Project
//
//  Created by Wandianga hassane on 02/11/2020.
//  Copyright © 2020 Wandianga. All rights reserved.
//

import UIKit
//TODO: delete
class HomeTabBarController: UITabBarController {

     // MARK: - init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        UITabBarItem.appearance()
        
        let appearanceTabBar = UIBarAppearance()
        appearanceTabBar.backgroundColor = UIColor(named: "brown")
        
        
        hidesBottomBarWhenPushed = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
