//
//  JTDismissInteractiveTransition.swift
//  MyFramework
//
//  Created by JT on 2017/8/7.
//  Copyright © 2017年 JT. All rights reserved.
//

import UIKit

class JTViewControllerInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    private let finishPercent: CGFloat = 0.36
    private let fromVc: UIViewController
    private let popInteractiveTransition: () -> Void
    private let scrollView: UIScrollView?
    
    private var pan: UIPanGestureRecognizer = UIPanGestureRecognizer()

    var transitionInProgress: Bool = false
    var shouldCompleteTransition: Bool = false
    override var completionSpeed: CGFloat {
        get{
            return 1 - self.percentComplete
        }
        set{
            self.completionSpeed = newValue
        }
    }
    
    init(fromVc: UIViewController, scrollView: UIScrollView? = nil, popInteractiveTransition: @escaping () -> Void) {
        self.fromVc = fromVc
        self.popInteractiveTransition = popInteractiveTransition
        self.scrollView = scrollView

        super.init()

        self.addPanGestureRecognizer()
    }
    
    internal func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.transitionInProgress {
            return false
        } else {
            return true
        }
    }
    
    private func addPanGestureRecognizer() {
        self.pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizer(_:)))
        self.pan.delegate = self
        self.pan.maximumNumberOfTouches = 1
        self.pan.minimumNumberOfTouches = 1
        
        self.fromVc.view.addGestureRecognizer(self.pan)
    }

    internal func panGestureRecognizer(_ pan: UIPanGestureRecognizer) {
        let state = pan.state
        switch state {
        case .began:
            let velocity = pan.velocity(in: pan.view?.superview)
            if velocity.x > 0 && fabsf(Float(velocity.x / velocity.y)) > 1 {
                self.transitionInProgress = true
                self.shouldCompleteTransition = false
                self.scrollView?.isScrollEnabled = false
                self.popInteractiveTransition()
            }
        case .changed:
            if self.transitionInProgress {
                if self.transitionInProgress {
                    let w = pan.translation(in: pan.view?.superview).x
                    let max = fmax(w / kScreenWidth, 0)
                    let progress: CGFloat = fmin(max, 1.0)
                    self.shouldCompleteTransition = progress > finishPercent
                    self.update(progress)
                }
            }
        case .ended:
            if self.transitionInProgress {
                if self.shouldCompleteTransition {
                    self.transitionInProgress = false
                    self.shouldCompleteTransition = false
                    self.scrollView?.isScrollEnabled = true
                    self.finish()
                } else {
                    self.transitionInProgress = false
                    self.shouldCompleteTransition = false
                    self.scrollView?.isScrollEnabled = true
                    self.cancel()
                }
            }
        default:
            if self.transitionInProgress {
                self.transitionInProgress = false
                self.shouldCompleteTransition = false
                self.scrollView?.isScrollEnabled = true
                self.cancel()
            }
        }
    }

}
