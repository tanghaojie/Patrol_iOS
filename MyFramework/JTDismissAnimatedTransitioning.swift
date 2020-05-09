//
//  CustomDismissAnimateController.swift
//  MyFramework
//
//  Created by JT on 2017/8/3.
//  Copyright © 2017年 JT. All rights reserved.
//

import Foundation

class JTDismissAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView

        let toView = toViewController.view!
        toView.frame = finalFrameForVC
        toView.alpha = 0.2

        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame = fromViewController.view.frame.offsetBy(dx: fromViewController.view.frame.width, dy: 0)
            toViewController.view.alpha = 1
        }, completion: {
            finish in
            
            if transitionContext.transitionWasCancelled {
                toView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}
