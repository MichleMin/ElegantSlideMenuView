//
//  ElegantSlideMenuView.swift
//  ElegantSlideMenuView
//
//  Created by Min on 2017/3/26.
//  Copyright © 2017年 cdu.com. All rights reserved.
//

import UIKit

public class ElegantSlideMenuView: UIView {
    
    /** 顶部标签视图高度,默认高度 40 */
    public var topScrollViewHeight: CGFloat = 40
    /** 顶部标签视图背景色 */
    public var topScrollViewBackgroundColor: UIColor = UIColor.white
    /** 所有的页标签数组 */
    public var viewArray:[ElegantSlideMenuDto] = []
    /** 页标签选中标题颜色,默认为酒红色 */
    public var tabItemSelectedTitleColor: UIColor = UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
    /** 页标签正常时标题颜色,默认为暗黑色 */
    public var tabItemNormalTitleColor: UIColor = UIColor(red: 61/255, green: 61/255, blue: 61/255, alpha: 1)
    /** 页标签选中时按钮背景颜色,默认为白色 */
    public var tabItemSelectedBackgroundColor: UIColor = UIColor.white
    /** 页标签正常时按钮背景颜色,默认为白色 */
    public var tabItemNormalBackgroundColor: UIColor = UIColor.white
    /** 页标签按钮字体大小，默认16 */
    public var tabItemFontSize: CGFloat = 16
    /** 页标签按钮宽度是否自适应 */
    public var isAutomatic: Bool = true
    /** 页标签按钮宽度, 默认50，在不自适应的情况下，必须设置按钮宽度 */
    public var tabItemWidth: CGFloat = 50
    /** 页标签按钮间隔，默认10 */
    public var tabItemSpace: CGFloat = 10
    /** 页标签是否设置边距，默认True */
    public var isSetTabItemMargin: Bool = true
    /** 页标签与两边的边距，默认9 */
    public var tabMargin: CGFloat = 9
    /** 页面跳转是否开启动画，默认开启 */
    public var isAnimated: Bool = true
    /** 更新当前页面数据，回传当前界面的索引值 */
    public var refreshDataBlock: ((_ index: Int)->Void)?
    /** 默认选中tap index，从 0 开始，默认 0 */
    public var defaultSelectedIndex: Int = 0
    /** 滚动条位置，默认 bottom */
    public var underLinePosition: UnderLinePosition = .bottom
    
    fileprivate var topScrollView: UIScrollView! //顶部标签视图
    fileprivate var rootScrollView: UIScrollView! // 主视图
    fileprivate var underLineLayer: UIView! // 滚动条
    fileprivate var btns: [UIButton] = [] //所有button
    fileprivate var topMaxOffsetX: CGFloat = 0.0 // 顶部标签最大偏移量
    fileprivate var minCount: Int! // topScrollView 最小偏移个数
    fileprivate var maxCount: Int! // topScrollView 最大偏移个数
    fileprivate var index: Int! = 0 // 当前选中的tap的索引
    fileprivate var tempIndexs: [Int] = [0] // 索引值数组
    fileprivate var indexFloat: CGFloat = 0.0 // rootScrollView 拖动距离的倍数
    fileprivate var tempIndex: Int = 0
    fileprivate var topScrollViewOffSetX: CGFloat = 0 // topScrollView 的 x 轴偏移量
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        topScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: topScrollViewHeight))
        topScrollView.backgroundColor = UIColor.blue
        topScrollView.isPagingEnabled = false
        topScrollView.showsVerticalScrollIndicator = false
        topScrollView.showsHorizontalScrollIndicator = false
        topScrollView.delegate = self
        topScrollView.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.addSubview(topScrollView)
        
        rootScrollView = UIScrollView(frame: CGRect(x: 0, y: topScrollViewHeight, width: self.frame.size.width, height: self.frame.size.height-topScrollViewHeight))
        rootScrollView.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
        rootScrollView.isPagingEnabled = true
        rootScrollView.showsHorizontalScrollIndicator = false
        rootScrollView.showsVerticalScrollIndicator = false
        rootScrollView.isUserInteractionEnabled = true
        rootScrollView.bounces = false
        rootScrollView.delegate = self
        rootScrollView.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin, .flexibleHeight]
        self.addSubview(rootScrollView)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** 重建UI */
    public func buildUI() {
        if !isSetTabItemMargin {
            tabMargin = 0
        }
        topScrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: topScrollViewHeight)
        topScrollView.backgroundColor = topScrollViewBackgroundColor
        rootScrollView.frame = CGRect(x: 0, y: topScrollViewHeight, width: self.frame.size.width, height: self.frame.size.height-topScrollViewHeight)
        rootScrollView.contentSize = CGSize(width: self.frame.size.width*CGFloat(viewArray.count), height: 0)
        
        if isAutomatic {
            topScrollView.isScrollEnabled = false
            topScrollView.contentSize = CGSize(width: self.frame.size.width-2*tabMargin, height: 0)
            tabItemWidth = (topScrollView.frame.size.width-CGFloat(viewArray.count-1)*tabItemSpace-tabMargin*2)/CGFloat(viewArray.count)
        }else{
            topScrollView.contentSize = CGSize(width: CGFloat(viewArray.count)*tabItemWidth+CGFloat(viewArray.count-1)*tabItemSpace+2*tabMargin, height: 0)
        }
        
        underLineLayer = UIView()
        let underLinelayerX = tabMargin+CGFloat(defaultSelectedIndex)*(tabItemWidth+tabItemSpace)
        let underLineLayerY = underLinePosition == .bottom ? topScrollViewHeight-2:0
        underLineLayer.frame =  CGRect(x: underLinelayerX, y: underLineLayerY, width: tabItemWidth, height: 1.5)
        underLineLayer.backgroundColor = tabItemSelectedTitleColor
        topScrollView.addSubview(underLineLayer)
        
        createTopScrollViewSplite()
        
        for i in 0..<viewArray.count {
            let slideSwitchDto = viewArray[i]
            let tabItemOffsetX = CGFloat(i)*(tabItemWidth+tabItemSpace)+tabMargin
            let y: CGFloat = underLinePosition == .bottom ? 0:1.5
            let frame = CGRect(x: tabItemOffsetX, y: y, width: tabItemWidth, height: topScrollViewHeight-2)
            buidBtn(title: slideSwitchDto.title, frame: frame, tag: i)
            let rootViewOffSeX = CGFloat(i)*self.frame.size.width
            slideSwitchDto.view.frame.origin = CGPoint(x: rootViewOffSeX,y: 0)
            slideSwitchDto.view.frame.size = CGSize(width: self.frame.size.width, height: self.frame.size.height-topScrollViewHeight)
            rootScrollView.addSubview(slideSwitchDto.view)
        }
        
        topMaxOffsetX = topScrollView.contentSize.width - self.frame.size.width
        // 屏幕能容纳的页标签按钮个数
        let btnCount = (self.frame.size.width-2*tabMargin+tabItemSpace)/(tabItemWidth+tabItemSpace)
        minCount = lroundf(Float(btnCount/2))
        maxCount = lroundf(Float(topMaxOffsetX/(tabItemWidth+tabItemSpace)))
        
        // 设置默认选中tap index 不为 0 时，使 rootScrollView 偏移
        rootScrollView.contentOffset = CGPoint(x: CGFloat(defaultSelectedIndex)*self.frame.size.width,y: 0)
    }
    
    /** 给顶部标签栏添加一条分割线 */
    func createTopScrollViewSplite(){
        let frame = CGRect(x: 0, y: topScrollViewHeight-0.3, width: self.frame.size.width, height: 0.3)
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 121/255, green: 121/255, blue: 121/255, alpha: 1).cgColor
        layer.frame = frame
        topScrollView.layer.addSublayer(layer)
    }
    
    /** 创建页标签按钮 */
    func buidBtn(title: String,frame: CGRect,tag: Int) {
        let buttont = UIButton(type: UIButtonType.custom)
        buttont.frame = frame
        buttont.tag = tag
        buttont.titleLabel?.font = autoAdjustFontSize(fontSize: tabItemFontSize)
        buttont.setTitle(title, for: UIControlState.normal)
        buttont.setTitleColor(tabItemNormalTitleColor, for: UIControlState.normal)
        buttont.setTitleColor(tabItemSelectedTitleColor, for: UIControlState.selected)
        buttont.addTarget(self, action: #selector(ElegantSlideMenuView.selectedNameButton(sender:)), for: UIControlEvents.touchUpInside)
        if tag == defaultSelectedIndex{
            buttont.isSelected = true
        }else{
            buttont.isSelected = false
        }
        if buttont.isSelected{
            buttont.backgroundColor = tabItemSelectedBackgroundColor
        }else{
            buttont.backgroundColor = tabItemNormalBackgroundColor
        }
        btns.append(buttont)
        topScrollView.addSubview(buttont)
    }
    
    /** 选中按钮时，所要执行的动作 */
    func selectedNameButton(sender: UIButton) {
        self.rootScrollView.setContentOffset(CGPoint(x: CGFloat(sender.tag)*self.frame.size.width,y: 0), animated: isAnimated)
        if !isAutomatic{
            if sender.tag < minCount {
                topScrollViewOffSetX = 0
            }else if sender.tag >= minCount && sender.tag <= (maxCount+minCount){
                topScrollViewOffSetX = (tabItemSpace+tabItemWidth)*(CGFloat(sender.tag-minCount))+tabMargin
            }else{
                topScrollViewOffSetX = topMaxOffsetX
            }
            self.topScrollView.setContentOffset(CGPoint(x:topScrollViewOffSetX, y: 0), animated: true)
        }
        if !tempIndexs.contains(sender.tag){
            if index != sender.tag{
                index = sender.tag
                tempIndexs.append(index)
                if refreshDataBlock != nil {
                    refreshDataBlock!(index)
                }
            }
        }
    }
    
    /** 根据屏幕宽度自动调整字体大小 */
    func autoAdjustFontSize(fontSize: CGFloat) -> UIFont {
        let screenWidth = UIScreen.main.bounds.size.width
        if screenWidth == 320 {
            return UIFont.systemFont(ofSize: fontSize*(320/414))
        }else if screenWidth == 375{
            return UIFont.systemFont(ofSize: fontSize*(375/414))
        }else{
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    /** 计算字符串的尺寸 */
    func getStringSize(str: String,font: UIFont)->CGSize{
        let attributes = [NSFontAttributeName: font]
        let size = (str as NSString).size(attributes: attributes)
        return size
    }
    
}

extension ElegantSlideMenuView: UIScrollViewDelegate {
    
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = self.frame.size.width
        if scrollView == rootScrollView{
            indexFloat = scrollView.contentOffset.x/width
            tempIndex = Int(indexFloat)
            // 动态更改页标签按钮状态
            if indexFloat < (0.3+CGFloat(tempIndex)){
                btns.forEach({ (btn) in
                    if btn.tag != tempIndex{
                        btn.isSelected = false
                    }else{
                        btn.isSelected = true
                    }
                })
            }else if indexFloat > (0.3+CGFloat(tempIndex)) && indexFloat < (0.7+CGFloat(tempIndex)){
                btns.forEach({ (btn) in
                    if btn.tag != tempIndex || btn.tag != tempIndex+1{
                        btn.isSelected = false
                    }else{
                        btn.isSelected = true
                    }
                })
            }else if indexFloat > (0.7+CGFloat(tempIndex)){
                btns.forEach({ (btn) in
                    if btn.tag != tempIndex+1{
                        btn.isSelected = false
                    }else{
                        btn.isSelected = true
                    }
                })
            }
            // 滚动条每次需要滚动的距离
            let underLineOffsetX = tabItemSpace+tabItemWidth
            // 滚动条
            underLineLayer.frame.origin.x = (scrollView.contentOffset.x/width)*underLineOffsetX+tabMargin
            if !isAutomatic {
                // 当根视图滑过当前界面上页标签按钮一半时，滚动页标签
                // rootScrollView 滑动了几个屏幕宽度
                let count = Int(rootScrollView.contentOffset.x/width)
                
                if count < minCount{
                    topScrollViewOffSetX = 0
                }else if count >= minCount && count <= (maxCount+minCount) {
                    if (count - minCount) == maxCount{
                        topScrollViewOffSetX = topMaxOffsetX
                    }else{
                        topScrollViewOffSetX = (tabItemSpace+tabItemWidth)*(CGFloat(count-minCount))+tabMargin
                    }
                }else{
                    topScrollViewOffSetX = topMaxOffsetX
                }
            }
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if scrollView == rootScrollView{
            topScrollView.setContentOffset(CGPoint(x: topScrollViewOffSetX, y: 0), animated: true)
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let width = self.frame.size.width
        let tempIndex = Int(scrollView.contentOffset.x/width)
        if !tempIndexs.contains(tempIndex){
            if index != tempIndex{
                index = tempIndex
                tempIndexs.append(index)
                if refreshDataBlock != nil {
                    refreshDataBlock!(index)
                }
            }
        }
    }
}

/** 滚动条位置 */
public enum UnderLinePosition{
    case top
    case bottom
}
