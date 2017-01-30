//
//  MainVC.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/29.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Follow")
        addChildVc("Profile")

        // Do any additional setup after loading the view.
    }

  
    fileprivate func addChildVc(_ storyName : String) {
        // 1.通过storyboard获取控制器
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2.将childVc作为子控制器
        addChildViewController(childVc)
    }

    
}
