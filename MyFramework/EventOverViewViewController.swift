//
//  EventOverViewViewController.swift
//  MyFramework
//
//  Created by JT on 2017/7/20.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventOverViewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

}

extension EventOverViewViewController {
    
    fileprivate func setupUI() {
        self.view.backgroundColor = UIColor(red: 245, green: 245, blue: 245)
        setupBackButton()
        
    }
    
    private func setupBackButton(){
        let img = UIImage(named: "leftArrow")?.withRenderingMode(.alwaysOriginal)
        let leftBtn = UIBarButtonItem(image: img, style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.leftBarButtonItem = leftBtn;
    }
    
    func backButtonAction(){
        let navi = self.navigationController
        navi?.dismiss(animated: true, completion: nil)
    }
    
    
}
