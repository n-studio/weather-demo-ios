//
//  CellTransition.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/22.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CellTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.35
    var pop = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        if pop {

        }
        else {
            let fromView = fromViewController!.view!
            let toView = toViewController!.view
            toView?.alpha = 0

            containerView.addSubview(fromView)
            containerView.addSubview(toView!)

            UIView.animate(withDuration: animationDuration, animations: {
                fromView.alpha = 0
                toView?.alpha = 1
            }) { finished in
                if finished {
                    fromView.transform = CGAffineTransform.identity
                    transitionContext.completeTransition(true)
                }
            }
        }
    }
}
