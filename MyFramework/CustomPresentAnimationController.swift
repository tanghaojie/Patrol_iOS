//
//  CustomPresentAnimationController.swift
//  MyFramework
//
//  Created by JT on 2017/8/3.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

class CustomPresentAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        let bounds = UIScreen.main.bounds
        toViewController.view.frame = finalFrameForVC.offsetBy(dx: bounds.size.width, dy: 0)
        containerView.addSubview(toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.alpha = 0.5
            toViewController.view.frame = finalFrameForVC
        }, completion: {
            finish in
            transitionContext.completeTransition(true)
            fromViewController.view.alpha = 1.0
        })
        
    }
    
}
