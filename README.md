# ElegantSlideMenuView
一个优雅的横向滑动导航栏菜单，只需几行简短的代码，即可帮你实现一个带有简单动画功能的横向可滑动的导航栏菜单。

目前只支持竖屏。

![image](https://github.com/MichleMin/ElegantSlideMenuView/blob/master/ScreenShots/image1.png)
![image](https://github.com/MichleMin/ElegantSlideMenuView/blob/master/ScreenShots/image2.png)

## 一. Installation 安装
   * CocoaPods: pod 'ElegantSlideMenuView'
   * 手动导入：直接将 ElegantSlideMenuView.xcodeproj 文件拽入项目中，导入文件：import ElegantSlideMenuView

## 二. Example 例子
```swift
   // 初始化标题栏 title
  let titles = ["推荐","下线","餐厨","配件","服装","洗护","婴童","杂货"]
  // 初始化导航栏菜单
  let elegantSlideMenuView = ElegantSlideMenuView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height))
  // 设置导航栏菜单的一些属性
  elegantSlideMenuView.isAutomatic = true
  elegantSlideMenuView.tabItemSelectedTitleColor = UIColor.blue
  elegantSlideMenuView.defaultSelectedIndex = 1
  let width = self.view.frame.size.width
  let height = self.view.frame.size.height - 40 - 64
  let frame = CGRect(x: 0, y: 0, width: width, height: height
  // 循环生成子 View ，并添加到导航栏菜单中
  for i in 0..<titles.count{
      let kitchenView = UIView(frame: frame)
      let rgb = CGFloat(arc4random_uniform(255))/255
      kitchenView.backgroundColor = UIColor(red: rgb, green: rgb, blue: rgb, alpha: 1)
      var slideMenuDto = ElegantSlideMenuDto()
      slideMenuDto.title = titles[i]
      slideMenuDto.view = kitchenView
      elegantSlideMenuViewArray.append(slideMenuDto)
  }
  self.view.addSubview(elegantSlideMenuView)
  elegantSlideMenuView.viewArray = elegantSlideMenuViewArray
  elegantSlideMenuView.buildUI()
  // 通过 block 获取选中的 index 
  elegantSlideMenuView.refreshDataBlock = { index in
      print("\(index)")
  }
```
* 更多使用例子，请看工程里面的Demo
## 三. Requirements 要求
- iOS 8.0+
- Swift 3
