//
//  TaskViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class TaskViewController: UINavigationController, UIViewControllerTransitioningDelegate, JTViewControllerInteractiveTransitionDelegate  {

    var jtViewControllerInteractiveTransition: JTViewControllerInteractiveTransition? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 248, green: 248, blue: 248)
        self.navigationBar.barTintColor = kMainColor
        
        self.transitioningDelegate = self
        
        let sb = UIStoryboard(name: "TaskSB", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TaskSBViewController") as! TaskSBViewController
        self.pushViewController(vc, animated: true)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        if let jtPop = self.jtViewControllerInteractiveTransition {
            return jtPop.transitionInProgress ? jtPop : nil
        }
        return nil
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimationController()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimateController()
    }

    
    
}


