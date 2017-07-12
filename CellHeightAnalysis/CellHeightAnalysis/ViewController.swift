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

    func initData() {
        objc_setAssociatedObject(self,
                                 &runtimeKey.miKey,
                                 Box.init(value: "23"),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        objc_setAssociatedObject(self,
                                 &runtimeKey.miKey2,
                                 Box.init(value: 99),
                                 objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func initUI() {
        
        self.view.backgroundColor
        
    }
    
    func showAssociated() {
        let oneInBox = (objc_getAssociatedObject(self, &runtimeKey.miKey) as? Box<String>)?.outValue
        let twoInBox = (objc_getAssociatedObject(self, &runtimeKey.miKey2) as? Box<NSInteger>)?.outValue
        
        print("one = \(oneInBox)")
        print("two = \(twoInBox)")
        
    }

}


