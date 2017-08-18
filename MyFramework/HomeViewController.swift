//
//  MyHomeViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/12.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class HomeViewController: UINavigationController, UIViewControllerTransitioningDelegate, JTViewControllerInteractiveTransitionDelegate  {

    var jtViewControllerInteractiveTransition: JTViewControllerInteractiveTransition? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor
        
        self.transitioningDelegate = self

        self.pushViewController(MyViewController(), animated: true)
    }
    
    deinit {
        print("------release homeViewController ok")
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if let jtVCInteractiveTransition = self.jtViewControllerInteractiveTransition {
            return jtVCInteractiveTransition.transitionInProgress ? jtVCInteractiveTransition : nil
        }
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTPresentAnimatedTransitioning()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return JTDismissAnimatedTransitioning()
    }
    

}
