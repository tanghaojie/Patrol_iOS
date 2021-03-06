//
//  CustomNavigationAnimationController.swift
//  MyFramework
//
//  Created by JT on 2017/8/4.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTNavigationControllerAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    var reverse: Bool = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        
        toView.frame = finalFrameForVC.offsetBy(dx: (self.reverse ? -1 : 1) * finalFrameForVC.width, dy: 0)
        toViewController.view.alpha = 0.2
        fromViewController.view.alpha = 1
        
        containerView.addSubview(toView)
        containerView.sendSubviewToBack(toView)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            let x = (self.reverse ? 1 : -1 ) * fromView.frame.width
            fromView.frame = fromView.frame.offsetBy(dx: x, dy: 0)
            toView.frame = finalFrameForVC
            toView.alpha = 1
            fromView.alpha = 0.8
        }, completion: {
            finish in
            
            if transitionContext.transitionWasCancelled {
                fromView.alpha = 1
            } else {
                fromView.removeFromSuperview()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
