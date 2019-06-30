//
//  CityDetailViewSegue.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/30.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CityDetailViewSegue: UIStoryboardSegue {
    private var selfRetainer: CityDetailViewSegue? = nil
    let transition = CellTransition()

    override func perform() {
        destination.transitioningDelegate = self
        selfRetainer = self
        destination.modalPresentationStyle = .fullScreen
        source.present(destination, animated: true, completion: nil)
    }
}

extension CityDetailViewSegue: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.pop = false
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        selfRetainer = nil
        transition.pop = true
        return transition
    }
}
