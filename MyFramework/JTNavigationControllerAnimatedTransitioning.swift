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
        return 0.15
    }
    
//    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
//        let containerView = transitionContext.containerView
//        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
//        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
//        let toView = toViewController.view
//        let fromView = fromViewController.view
//        let direction: CGFloat = reverse ? -1 : 1
//        let const: CGFloat = -0.005
//        
//        toView?.layer.anchorPoint = CGPoint(x: direction == 1 ? 0 : 1, y: 0.5)
//        fromView?.layer.anchorPoint = CGPoint(x: direction == 1 ? 1 : 0, y: 0.5)
//        
//        var viewFromTransform: CATransform3D = CATransform3DMakeRotation(direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
//        var viewToTransform: CATransform3D = CATransform3DMakeRotation(-direction * CGFloat(M_PI_2), 0.0, 1.0, 0.0)
//        viewFromTransform.m34 = const
//        viewToTransform.m34 = const
//        
//        containerView.transform = CGAffineTransform(translationX: direction * containerView.frame.size.width / 2.0, y: 0)
//        toView?.layer.transform = viewToTransform
//        containerView.addSubview(toView!)
//        
//        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
//            containerView.transform = CGAffineTransform(translationX: -direction * containerView.frame.size.width / 2.0, y: 0)
//            fromView?.layer.transform = viewFromTransform
//            toView?.layer.transform = CATransform3DIdentity
//        }, completion: {
//            finished in
//            containerView.transform = CGAffineTransform.identity
//            fromView?.layer.transform = CATransform3DIdentity
//            toView?.layer.transform = CATransform3DIdentity
//            fromView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            toView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//            
//            if (transitionContext.transitionWasCancelled) {
//                toView?.removeFromSuperview()
//            } else {
//                fromView?.removeFromSuperview()
//            }
//            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
//        })
//        
//    }
    
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
        containerView.sendSubview(toBack: toView)
        
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
