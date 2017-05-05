//
//  Demo02ViewController.swift
//  iOSDemo
//
//  Created by Min on 2017/3/26.
//  Copyright © 2017年 cdu.com. All rights reserved.
//

import UIKit
import ElegantSlideMenuView

class Demo02ViewController: UIViewController {
    
    var elegantSlideMenuView: ElegantSlideMenuView!
    var elegantSlideMenuViewArray: [ElegantSlideMenuDto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSliderMenuView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initSliderMenuView() {
        let titles = ["推荐","下线","餐厨屋","配件","服装城","洗护","婴童","杂货","爱乐","美食","休闲"]
        elegantSlideMenuView = ElegantSlideMenuView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height))
        elegantSlideMenuView.isAutomatic = false
//        elegantSlideMenuView.tabItemWidth = 70
        getElegantSlideMenuView(titles: titles)
        self.view.addSubview(elegantSlideMenuView)
        elegantSlideMenuView.viewArray = elegantSlideMenuViewArray
        elegantSlideMenuView.refreshDataBlock = { index in
            print("\(index)")
        }
        elegantSlideMenuView.buildUI()
    }
    
    func getElegantSlideMenuView(titles: [String]){
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height - 40 - 64
        
        for i in 0..<titles.count{
            if i == 0{
                let demoBaseView = DemoBaseView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                var slideMenuDto = ElegantSlideMenuDto()
                slideMenuDto.title = titles[i]
                slideMenuDto.view = demoBaseView
                elegantSlideMenuViewArray.append(slideMenuDto)
            }else if i == 1{
                let demoBaseView = MySubordinateTableView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                var slideMenuDto = ElegantSlideMenuDto()
                slideMenuDto.title = titles[i]
                slideMenuDto.view = demoBaseView
                elegantSlideMenuViewArray.append(slideMenuDto)
            }else{
                let kitchenView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                let rgb = CGFloat(arc4random_uniform(255))/255
                kitchenView.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
                var slideMenuDto = ElegantSlideMenuDto()
                slideMenuDto.title = titles[i]
                slideMenuDto.view = kitchenView
                elegantSlideMenuViewArray.append(slideMenuDto)
            }
        }
    }
}
