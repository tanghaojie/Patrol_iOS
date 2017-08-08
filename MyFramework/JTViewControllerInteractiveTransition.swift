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
    
    init(fromVc: UIViewController, popInteractiveTransition: @escaping () -> Void) {
        self.fromVc = fromVc
        self.popInteractiveTransition = popInteractiveTransition

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
                print("began")
                
                self.transitionInProgress = true
                self.shouldCompleteTransition = false
                self.popInteractiveTransition()
            }
        case .changed:
            if self.transitionInProgress {
                if self.transitionInProgress {
                    print("change")
                    let w = pan.translation(in: pan.view?.superview).x
                    let max = fmax(w / kScreenWidth, 0)
                    let progress: CGFloat = fmin(max, 1.0)
                    self.shouldCompleteTransition = progress > finishPercent
                    print(progress)
                    self.update(progress)
                }
            }
        case .ended:
            if self.transitionInProgress {
                if self.shouldCompleteTransition {
                    self.transitionInProgress = false
                    self.shouldCompleteTransition = false
                    print("finish")
                    self.finish()
                } else {
                    self.transitionInProgress = false
                    self.shouldCompleteTransition = false
                    print("cancel")
                    self.cancel()
                }
            }
        default:
            if self.transitionInProgress {
                print("default")
                self.transitionInProgress = false
                self.shouldCompleteTransition = false
                self.cancel()
            }
        }
    }

}