//
//  CustomDismissAnimateController.swift
//  MyFramework
//
//  Created by JT on 2017/8/3.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

class CustomDismissAnimateController: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.8
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView

        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.width, dy: 0)
            toViewController.view.alpha = 1
        }, completion: {
            finish in
            transitionContext.completeTransition(true)
        })
        
    }
}
