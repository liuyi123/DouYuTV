//
//  pageContentView.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/31.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit
private let ContentCellID = "ContentCellID"
protocol xxxxxxxDelegate : class {
    
    
    // func contentPage(page : Int)
    
    
    func xxxxxxyyyyy(_ contentView: pageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class pageContentView: UIView {

     fileprivate var childVcs : [UIViewController]
     fileprivate weak var parentViewController : UIViewController?
     fileprivate var startOffsetX : CGFloat = 0
     fileprivate var isForbidScrollDelegate : Bool = false
      weak var delegate : xxxxxxxDelegate?
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
         collectionView.delegate = self
        
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
            
            parentViewController?.addChildViewController(childVC)
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

extension pageContentView : UICollectionViewDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 0.判断是否是点击事件
        if isForbidScrollDelegate { return }
        
        // 1.定义获取需要的数据
        var progress : CGFloat = 0
        var sourceIndex : Int = 0
        var targetIndex : Int = 0
        
        // 2.判断是左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左滑
            // 1.计算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.计算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            
            // 4.如果完全划过去
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else { // 右滑
            // 1.计算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.计算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.计算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.将progress/sourceIndex/targetIndex传递给titleView
        delegate?.xxxxxxyyyyy(self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let scrollViewW = scrollView.bounds.width
        
        let page = scrollView.contentOffset.x/scrollViewW
        
       // delegate?.contentPage(page: Int(page))
        
         print("yy:*@",page)
    }
    
}

// MARK:- 对外暴露的方法
extension pageContentView {
    func setCurrentIndex(_ currentIndex : Int) {
        
        // 1.记录需要进制执行代理方法
        isForbidScrollDelegate = true
        
        // 2.滚动正确的位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
