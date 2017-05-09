//
//  PullDownAnimationController.swift
//  InteractiveModalTransition
//
//  Created by Emil Gräs on 09/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class PullDownAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    
    enum TransitionType {
        case presenting
        case dismissing
    }
    
    let transitionType: TransitionType
    
    init(transitionType: TransitionType) {
        self.transitionType = transitionType
        
        super.init()
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let inView   = transitionContext.containerView
        let toView   = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        var frame = inView.bounds
        
        switch transitionType {
        case .presenting:
            frame.origin.y = frame.size.height
            toView.frame = frame
            
            inView.addSubview(toView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                toView.frame = inView.bounds
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        case .dismissing:
            toView.frame = frame
            inView.insertSubview(toView, belowSubview: fromView)
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0.0, options: .curveEaseInOut, animations: {
                frame.origin.y = frame.size.height
                fromView.frame = frame
            }, completion: { finished in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
}

class PresentationController: UIPresentationController {
    override var shouldRemovePresentersView: Bool { return true }
}
