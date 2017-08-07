//
//  EventViewController.swift
//  MyFramework
//
//  Created by JT on 2017/6/15.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class EventViewController: UINavigationController, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {
    
    let customInteractionController = CustomInteractionController()
    let customNavigationAnimationController = CustomNavigationAnimationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = kMainColor
        //self.delegate = self
        
        self.pushViewController(EventOverViewViewController(), animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            customInteractionController.addGestureRecognizerToViewController(toVC)
        }
        customNavigationAnimationController.reverse = operation == .pop
        return customNavigationAnimationController
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        
        let inProgress = customInteractionController.transitionInProgress
        return inProgress ? customInteractionController : nil
    }

}
