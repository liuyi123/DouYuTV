//
//  PageTitleView.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/31.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit
// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    fileprivate var titles : [String]

    // MARK:- 懒加载属性
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var scrollView : UIScrollView={
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView;
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()

     // MARK:- 自定义构造函数
    init(frame: CGRect, titles: [String]) {
        self.titles=titles;
        super.init(frame:frame)
        
        // 设置UI界面
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
extension PageTitleView{
    fileprivate func setupUI(){
   

        
       // 1.添加UIScrollView
       addSubview(scrollView)
        scrollView.frame=bounds
   
        
       // 2.添加title对应的Label
        setupTitleLabels()
        //3.给Label添加底线
        setupBottomLineAndScrollLine()
        
    
    }
    
    
    fileprivate func setupTitleLabels(){
         //let lableX=40;
        
         let lableH:CGFloat = frame.size.height-kScrollLineH
         let lableW:CGFloat = frame.size.width/CGFloat(titles.count)
         let lableY:CGFloat = 0;
        
        for (index,title) in titles.enumerated() {
            let lableX=CGFloat(index) * lableW
            
           let label = UILabel()
            
            label.frame=CGRect(x: lableX, y: lableY, width: lableW, height: lableH)
            label.tag=index
            label.text=title;
            label.font=UIFont.systemFont(ofSize: 14)
            label.textAlignment = .center;
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            scrollView.addSubview(label)
            titleLabels.append(label)
        }
       
        
    
    }
    fileprivate func setupBottomLineAndScrollLine() {
        // 1.添加底线
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        
        // 2.1.获取第一个Label
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        
        // 2.2.设置scrollLine的属性
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        
        
        
        
    }
}
