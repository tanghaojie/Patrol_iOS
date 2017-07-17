//
//  EventViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sb = UIStoryboard(name: "EventReportSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EventReportSBViewController") as! EventReportSBViewController
        self.pushViewController(vc, animated: true)
    }

}
