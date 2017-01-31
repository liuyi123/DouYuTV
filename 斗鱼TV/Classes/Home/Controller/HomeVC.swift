//
//  HomeVC.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/29.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit
private let kTitleViewH : CGFloat = 40
class HomeVC: UIViewController {
    
    fileprivate lazy var pageContentViews : pageContentView = {[weak self] in
      
        
        let contentH = kScreenH - kStatusBarH - kNavigationBarH - kTitleViewH - kTabbarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        var childVCs=[UIViewController]()
        
        for _ in 0...4{
          let vc =  UIViewController()
            
            vc.view.backgroundColor=UIColor.randomColor()
            childVCs.append(vc)
        }
       
        let contentView = pageContentView(frame: contentFrame, childVcs: childVCs, parentViewController: self!)
        
        return contentView
    }()
    
    fileprivate lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavigationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        return titleView
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
                setupUI()
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
extension HomeVC {
    fileprivate func setupUI() {
        
        // 0.不需要调整UIScrollView的内边距
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.设置导航栏
        setupNavigationBar()
        // 2.添加TitleView
        view.addSubview(pageTitleView)
        // 2.添加pageContentView
        view.addSubview(pageContentViews)

        
    }
    fileprivate func setupNavigationBar() {
        // 1.设置左侧的Item
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 2.设置右侧的Item
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", highImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }


}
