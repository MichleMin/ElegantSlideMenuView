//
//  ViewController.swift
//  iOSDemo
//
//  Created by Min on 2017/3/26.
//  Copyright © 2017年 cdu.com. All rights reserved.
//

import UIKit
import ElegantSlideMenuView

class ViewController: UIViewController {

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
        let titles = ["推荐","居家","餐厨","配件","服装","洗护","婴童","杂货"]
        elegantSlideMenuView = ElegantSlideMenuView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height))
        elegantSlideMenuView.isAutomatic = true
        getElegantSlideMenuView(titles: titles)
        self.view.addSubview(elegantSlideMenuView)
        elegantSlideMenuView.viewArray = elegantSlideMenuViewArray
        elegantSlideMenuView.buildUI()
        elegantSlideMenuView.refreshDataBlock = { index in
            print("\(index)")
        }
    }
    
    func getElegantSlideMenuView(titles: [String]){
        let width = self.view.frame.size.width
        let height = self.view.frame.size.height - 40 - 64
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        for i in 0..<titles.count{
            if i == 0{
                let demoBaseView = DemoBaseView(frame: frame)
                var slideMenuDto = ElegantSlideMenuDto()
                slideMenuDto.title = titles[i]
                slideMenuDto.view = demoBaseView
                elegantSlideMenuViewArray.append(slideMenuDto)
            }else{
                let kitchenView = UIView(frame: frame)
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

