//
//  pageContentView.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/31.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit
private let ContentCellID = "ContentCellID"
class pageContentView: UIView {

     fileprivate var childVcs : [UIViewController]
     fileprivate var parentViewController : UIViewController
    //lazy
    
    fileprivate lazy var collectionView : UICollectionView={[weak self] in
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = (self?.bounds.size)!
        //行间距
        layout.minimumLineSpacing = 0
        //iteam间距
        layout.minimumInteritemSpacing = 0
        //水平滚动
        layout.scrollDirection = .horizontal
        
        let collectionView =  UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        //水平指示器
        collectionView.showsHorizontalScrollIndicator = false
        //分页
        collectionView.isPagingEnabled = true
        //超出内容滚动区域
        collectionView.bounces = false
  
        collectionView.register(UICollectionViewCell.self , forCellWithReuseIdentifier: ContentCellID)
        
         collectionView.dataSource = self
        // collectionView.delegate = self as! UICollectionViewDelegate?
        
        return collectionView
    }()
    
    
    
   
    init(frame: CGRect, childVcs : [UIViewController],parentViewController : UIViewController) {
        self.childVcs=childVcs
        self.parentViewController=parentViewController
        
        super.init(frame: frame)
        
       
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
extension pageContentView{
    fileprivate func setupUI(){
        
        for childVC in childVcs {
            
            parentViewController.addChildViewController(childVC)
        }
        
        addSubview(collectionView)
        collectionView.frame = bounds
    }
    

}
extension pageContentView :UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        
        // 2.给Cell设置内容
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
          let childVc = childVcs[indexPath.item]
         // childVc.view.frame = cell.contentView.bounds
          cell.contentView.addSubview(childVc.view)
        
        return cell
    }

}
