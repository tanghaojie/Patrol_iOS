//
//  TaskNaviTestViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class TaskNaviTestViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainTask = TaskViewController()
        self.pushViewController(mainTask, animated: true)
        self.view.isUserInteractionEnabled = true
        
        //test
        let btn = UIButton(frame: CGRect(x: 80, y: 0, width: 50, height: 50))
        btn.backgroundColor = UIColor.green

        btn.addTarget(self, action: #selector(self.xx), for: .touchUpInside)

        self.navigationBar.addSubview(btn)
    }
    
    @objc private func xx(){
        
        let vc = UIViewController()
        vc.title="asd"
        vc.view.backgroundColor = .yellow
        self.pushViewController(vc, animated: true)
    }
}
