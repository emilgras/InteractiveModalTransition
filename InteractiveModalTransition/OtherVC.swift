//
//  OtherVC.swift
//  InteractiveModalTransition
//
//  Created by Emil Gräs on 09/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class OtherVC: UIViewController {

    let customTransitionDelegate = TransitioningDelegate()
    var interactionController: UIPercentDrivenInteractiveTransition?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalPresentationStyle = .custom
        transitioningDelegate = customTransitionDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panUp = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(panUp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = max(translate.y / gesture.view!.bounds.size.height, 0)
        
        if gesture.state == .began {
            interactionController = UIPercentDrivenInteractiveTransition()
            customTransitionDelegate.interactionController = interactionController
            dismiss(animated: true)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended {
            let velocity = abs(gesture.velocity(in: gesture.view).y)
            if (percent > 0.5 && velocity == 0) || (velocity > 100 && percent > 0.0) {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        }
        
    }

}
