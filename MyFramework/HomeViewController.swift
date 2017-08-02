//
//  MyHomeViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/12.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class HomeViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor

        self.pushViewController(MyViewController(), animated: true)
    }
    

}
