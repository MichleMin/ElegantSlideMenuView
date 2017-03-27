//
//  MySubordinateTableViewController.swift
//  KWallet
//
//  Created by Min on 2017/3/21.
//  Copyright © 2017年 cdu.com. All rights reserved.
//

import UIKit

class MySubordinateTableView: UIView {
    
    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView = UITableView(frame: self.frame, style: UITableViewStyle.grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MySubordinateCell1", bundle: nil), forCellReuseIdentifier: "MySubordinateCell1")
        tableView.register(UINib(nibName: "MySubordinateCell2", bundle: nil), forCellReuseIdentifier: "MySubordinateCell2")
        self.addSubview(tableView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MySubordinateTableView: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySubordinateCell1", for: indexPath) as! MySubordinateCell1
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MySubordinateCell2", for: indexPath) as! MySubordinateCell2
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 8))
        view.backgroundColor = UIColor(red: 234/255, green: 233/255, blue: 233/255, alpha: 1)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
