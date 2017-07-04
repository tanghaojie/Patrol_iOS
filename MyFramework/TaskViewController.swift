//
//  TaskViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class TaskViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftBarBtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(TaskViewController.backToPrevious))
        //self.navigationItem.leftBarButtonItem = leftBarBtn
        
        let v1=UIViewController()
        v1.view.backgroundColor = .red
        v1.navigationItem.leftBarButtonItem=leftBarBtn
        self.pushViewController(v1, animated: true)
        
        let v2=UIViewController()
        v2.view.backgroundColor = .blue
        self.pushViewController(v2, animated: true)
        
        let v3=UIViewController()
        v3.view.backgroundColor = .green
        self.pushViewController(v3, animated: true)
        
        
        
//        let nn = self.navigationItem
//        nn.titleView?.backgroundColor = UIColor.red
//        
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0, y: 0, width: 65, height: 30)
//        //button.setImage(UIImage(named:"title"), for: .normal)
//        button.setTitle("title", for: .normal)
//        button.addTarget(self, action: #selector(TaskViewController.backToPrevious), for: .touchUpInside)
//        let leftBarBtn = UIBarButtonItem(customView: button)
//        //用于消除左边空隙，要不然按钮顶不到最前面
//        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
//        spacer.width = -10;
//        self.navigationItem.leftBarButtonItems = [spacer,leftBarBtn]


    }
    
    func backToPrevious(){
        let navi = self.navigationController
        navi?.popViewController(animated: true)
    }
    



}
