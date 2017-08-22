//
//  EventReportViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventReportViewController: UINavigationController {

    let reportSuccess: (()->())?
    
    init(reportSuccessFunc: (()->())? ) {
        reportSuccess = reportSuccessFunc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("---released EventReportViewController")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor

        let sb = UIStoryboard(name: "EventReportSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "EventReportSBViewController") as! EventReportSBViewController
        vc.reportSuccessFunc = reportSuccess
        self.pushViewController(vc, animated: true)
    }

}
