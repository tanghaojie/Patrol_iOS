//
//  EventViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventViewController: UINavigationController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate, JTViewControllerInteractiveTransitionDelegate {
    
    var jtViewControllerInteractiveTransition: JTViewControllerInteractiveTransition? = nil
    private let jtNavigationControllerAnimatedTransitioning = JTNavigationControllerAnimatedTransitioning()
    private var lastTop: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor
        self.delegate = self
        self.transitioningDelegate = self

        self.pushViewController(EventOverViewViewController(), animated: true)
    }

    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            self.lastTop = fromVC
        }

        jtNavigationControllerAnimatedTransitioning.reverse = operation == .pop
        return jtNavigationControllerAnimatedTransitioning
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        let jtVC = self.lastTop as? JTViewControllerInteractiveTransitionDelegate
        if let jt = jtVC {
            let jtVCInteractiveTransition = jt.jtViewControllerInteractiveTransition
            if let jtVCIT = jtVCInteractiveTransition {
                return jtVCIT.transitionInProgress ? jtVCIT : nil
            }
        }
        
        return nil
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
