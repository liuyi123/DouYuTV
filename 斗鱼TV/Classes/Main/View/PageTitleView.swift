//
//  PageTitleView.swift
//  斗鱼TV
//
//  Created by liuyi on 17/1/31.
//  Copyright © 2017年 liuyi. All rights reserved.
//

import UIKit

protocol PageTietleViewDelegate : class {
   
     func pageTitleView(_ titleView : PageTitleView, selectedIndex index : Int)
    
    
}

    
    
// MARK:- 定义常量
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

class PageTitleView: UIView {
    
    fileprivate var titles : [String]
    fileprivate var currentIndex : Int = 0
    weak var delegate : PageTietleViewDelegate?

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
            //添加手势
            label.isUserInteractionEnabled=true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)

            
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
    
    @objc func titleLabelClick(tapGes :UITapGestureRecognizer){
        
     guard  let currentLabel = tapGes.view as? UILabel else { return }
            let  oldLabel = titleLabels[currentIndex]
        
      
        
           // 1.如果是重复点击同一个Title,那么直接返回
          if currentLabel.tag == currentIndex { return }
        
            currentLabel.textColor=UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
            oldLabel.textColor=UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
            currentIndex=currentLabel.tag
    
        
        
        // 5.滚动条位置发生改变
     //   self.scrollLine.frame=CGRect(x: currentLabel.frame.origin.x, y: frame.height - kScrollLineH, width: currentLabel.frame.size.width, height: kScrollLineH)
        
        
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
          
            
            self?.scrollLine.frame.origin.x = scrollLineX
            
            
           
        })
        
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
        
    }
}
// MARK:- 对外暴露的方法
extension PageTitleView {
    func setCurrentPage(_ page : Int) {
        
        if page > titles.count-1 {
            return
        }
       
        for label :UILabel in titleLabels {
            
          
            
            if label.tag == page {
                label.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)

            }else{
                label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            }
            
        }
        
         currentIndex=page
        
        let scrollLineX = CGFloat(currentIndex) * scrollLine.frame.width
        
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            
            
            self?.scrollLine.frame.origin.x = scrollLineX
            
            
            
        })

        
        
    }
    
    func setTitleWithProgress(_ progress : CGFloat, sourceIndex : Int, targetIndex : Int) {
        // 1.取出sourceLabel/targetLabel
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.处理滑块的逻辑
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.颜色的渐变(复杂)
        // 3.1.取出变化的范围
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        
        // 3.2.变化sourceLabel
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        
        // 3.2.变化targetLabel
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 4.记录最新的index
        currentIndex = targetIndex
    }


}
