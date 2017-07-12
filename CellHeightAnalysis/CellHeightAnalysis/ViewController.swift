//
//  ViewController.swift
//  CellHeightAnalysis
//
//  Created by 11111 on 2017/7/12.
//  Copyright © 2017年 ZheJiang WanHang Mdt InfoTech CO.,Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var cellKey = "demoCellKey"
    
    lazy var demoTableView: UITableView = {
        let inner = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight),
                                     style: UITableViewStyle.grouped)
        inner.delegate = self
        inner.dataSource = self
        inner.separatorStyle = UITableViewCellSeparatorStyle.none
        return inner
    }()
    
    func initUI() {
        
        self.view.backgroundColor = ColorMethodho(hexValue: 0xffffff)
        demoTableView.register(TableViewCell.self, forCellReuseIdentifier: cellKey)
        self.view.addSubview(demoTableView)
    }
    
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let cacheKey = String.init(format: "%d", indexPath.row) + "~demo"
        
        let height = tableView.cellHeightCacheWith(identifier: cellKey,
                                                   cacheKey: cacheKey) { (cell) in
                                                    let randomHeight = indexPath.row * 4 + 50
                                                    (cell as! TableViewCell).heightCatch = CGFloat.init(randomHeight)
        }
        return height
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = tableView.dequeueReusableCell(withIdentifier: cellKey) as! TableViewCell
        cell.heightCatch = CGFloat.init(indexPath.row * 4 + 50)
        return cell
        
    }
}
