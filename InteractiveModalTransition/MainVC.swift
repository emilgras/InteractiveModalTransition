//
//  MainVC.swift
//  InteractiveModalTransition
//
//  Created by Emil Gräs on 09/05/2017.
//  Copyright © 2017 Emil Gräs. All rights reserved.
//

import UIKit

class MainVC: UIViewController {

    var interactionController: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panDown = UIPanGestureRecognizer(target: self, action: #selector(handleGesture))
        view.addGestureRecognizer(panDown)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // pan down transitions to next view controller
    func handleGesture(_ gesture: UIPanGestureRecognizer) {
        let translate = gesture.translation(in: gesture.view)
        let percent   = max(-translate.y / gesture.view!.bounds.size.height, 0)
        print("perc: \(percent)")
        if gesture.state == .began {
            let controller = storyboard!.instantiateViewController(withIdentifier: "OtherVC") as! OtherVC
            interactionController = UIPercentDrivenInteractiveTransition()
            controller.customTransitionDelegate.interactionController = interactionController
            show(controller, sender: self)
        } else if gesture.state == .changed {
            interactionController?.update(percent)
        } else if gesture.state == .ended || gesture.state == .cancelled {
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
