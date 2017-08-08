//
//  JTDismissInteractiveTransition.swift
//  MyFramework
//
//  Created by JT on 2017/8/7.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTDismissInteractiveTransition: UIPercentDrivenInteractiveTransition {
    

    func addGestureRecognizer(fromVc: UIViewController) {
        addTapGestureRecognizer(fromVc: fromVc)
        addRightSwipeGestureRecognizer(fromVc: fromVc)
    }
    
    private func addTapGestureRecognizer(fromVc: UIViewController) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer(_:)))
        fromVc.view.addGestureRecognizer(tap)
    }
    
    internal func tapGestureRecognizer(_ tap: UITapGestureRecognizer) {
        
    }
    
    private func addRightSwipeGestureRecognizer(fromVc: UIViewController) {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightGestureRecognizer(_:)))
        swipe.direction = .right
        fromVc.view.addGestureRecognizer(swipe)
    }
    
    internal func swipeRightGestureRecognizer(_ swipe: UISwipeGestureRecognizer) {
        
    }
    
}
