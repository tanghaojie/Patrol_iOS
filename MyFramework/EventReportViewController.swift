//
//  EventReportViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventReportViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor

        let sb = UIStoryboard(name: "EventReportSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EventReportSBViewController") as! EventReportSBViewController
        self.pushViewController(vc, animated: true)
    }

}
