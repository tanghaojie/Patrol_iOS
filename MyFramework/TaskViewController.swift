//
//  TaskViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class TaskViewController: UINavigationController  {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        self.navigationBar.barTintColor = kMainColor
        
        let sb = UIStoryboard(name: "TaskSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TaskSBViewController") as! TaskSBViewController
        self.pushViewController(vc, animated: true)
    }
}

// JackieTang test

