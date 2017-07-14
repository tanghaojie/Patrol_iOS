//
//  CustomTabbarView.swift
//  MyFramework
//
//  Created by JT on 2017/6/10.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class CustomTabbarView: UIView {
    
    fileprivate var titles : [String]
    fileprivate var images : [String?]
    fileprivate var jumps : [(()->())?]
    
    init(frame : CGRect,titles : [String] , images : [String?] , jumps : [(()->())?]){
        self.titles = titles
        self.images = images
        self.jumps = jumps
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        
        setupUI()
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomTabbarView {
    
    fileprivate func setupUI(){
        setupLabels()
    }
    
    private func setupLabels(){
        
        let W = self.frame.width/CGFloat(self.titles.count)
        let H = self.frame.height
        
        for (index,title) in self.titles.enumerated(){
            let btn = UIButton(type: .system)
            
            btn.tag = index
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor(red: 68, green: 82, blue: 82), for: .normal)
            if(index < self.images.count){
                let img = UIImage(named: self.images[index]!)?.withRenderingMode(.alwaysOriginal)
                btn.setImage(img, for: .normal)}

            btn.adjustsImageWhenDisabled = false
            btn.adjustsImageWhenHighlighted = false
            let x = CGFloat(index) * W
            btn.frame = CGRect(x: x, y: 0, width: W, height: H)
            btn.titleLabel?.lineBreakMode = .byCharWrapping
            self.addSubview(btn)
        
            btn.addTarget(self, action: #selector(self.buttonClick(btn:)), for: .touchUpInside)
        }
    }
    
    @objc private func buttonClick(btn : UIButton){
        let btnIndex = btn.tag
        //print("button click" + String(btnIndex))
        if(btnIndex < self.jumps.count){
            let jump = self.jumps[btnIndex]
            if(jump != nil){
                jump!()}
        }
    }
}
