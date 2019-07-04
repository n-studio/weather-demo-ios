//
//  CellTransition.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/22.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CellTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let animationDuration = 0.5
    var pop = false

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationDuration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        let containerView = transitionContext.containerView

        if pop {
            guard let toViewController = toViewController as? MainViewController else { return }

            let toBackgroundView = UIImageView(image: toViewController.selectedCellImage)
            toBackgroundView.backgroundColor = .black
            toBackgroundView.contentMode = .scaleAspectFill
            toBackgroundView.layer.cornerRadius = 0
            toBackgroundView.layer.borderWidth = 1.0
            toBackgroundView.layer.borderColor = UIColor.clear.cgColor
            toBackgroundView.layer.masksToBounds = true
            toBackgroundView.layer.shouldRasterize = true
            toBackgroundView.layer.rasterizationScale = UIScreen.main.scale
            guard let toContentViewSnapshot = toViewController.selectedCellSnapshot else { return }
            toContentViewSnapshot.clipsToBounds = true
            toContentViewSnapshot.contentMode = .top
            guard let toView = toViewController.view else { return }

            toView.isHidden = true
            toBackgroundView.frame = CGRect(origin: .zero,
                                              size: containerView.bounds.size)
            toContentViewSnapshot.frame = toBackgroundView.frame
            toContentViewSnapshot.frame.origin.y = MainViewController.statusBarHeight()
            let tableView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: CityDetailViewController.tableViewHeaderHeight() + 10),
                                                 size: containerView.bounds.size))
            tableView.backgroundColor = .white
            tableView.topRoundedCorners(cornerRadii: CGSize(width: 10, height: 10))
            tableView.addShadow(offset: CGSize(width: 0, height: -10))

            let whiteBackground = UIView(frame: containerView.bounds)
            whiteBackground.backgroundColor = .white
            containerView.addSubview(whiteBackground)
            containerView.addSubview(toBackgroundView)
            containerView.addSubview(toContentViewSnapshot)
            containerView.addSubview(tableView)
            containerView.addSubview(toView)

            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                toBackgroundView.frame = CGRect(x: MainViewController.cellMargins.width / 2,
                                                y: MainViewController.statusBarHeight(),
                                                width: containerView.bounds.size.width - MainViewController.cellMargins.width,
                                                height: containerView.bounds.size.height - MainViewController.cellMargins.height)
                toBackgroundView.layer.cornerRadius = CityOverviewCell.cornerRadius
                tableView.frame.origin.y = containerView.bounds.height
            }) { finished in
                transitionContext.completeTransition(finished)
                toView.isHidden = false
            }
        }
        else {
            guard let fromViewController = fromViewController as? MainViewController else { return }
            guard let toViewController = toViewController as? CityDetailViewController else { return }

            let fromBackgroundView = UIImageView(image: fromViewController.selectedCellImage)
            fromBackgroundView.backgroundColor = .black
            fromBackgroundView.contentMode = .scaleAspectFill
            fromBackgroundView.layer.cornerRadius = CityOverviewCell.cornerRadius
            fromBackgroundView.layer.borderWidth = 1.0
            fromBackgroundView.layer.borderColor = UIColor.clear.cgColor
            fromBackgroundView.layer.masksToBounds = true
            fromBackgroundView.layer.shouldRasterize = true
            fromBackgroundView.layer.rasterizationScale = UIScreen.main.scale
            guard let fromContentViewSnapshot = fromViewController.selectedCellSnapshot else { return }
            fromContentViewSnapshot.clipsToBounds = true
            fromContentViewSnapshot.contentMode = .top
            guard let toView = toViewController.view else { return }

            toView.isHidden = true
            fromBackgroundView.frame = CGRect(origin: CGPoint(x: MainViewController.cellMargins.width / 2,
                                                              y: fromViewController.flowLayout?.headerReferenceSize.height ?? 0),
                                              size: fromContentViewSnapshot.bounds.size)
            fromContentViewSnapshot.frame = fromBackgroundView.frame
            let tableView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: containerView.bounds.height), size: containerView.bounds.size))
            tableView.backgroundColor = .white
            tableView.topRoundedCorners(cornerRadii: CGSize(width: 10, height: 10))
            tableView.addShadow(offset: CGSize(width: 0, height: -10))

            containerView.addSubview(fromBackgroundView)
            containerView.addSubview(fromContentViewSnapshot)
            containerView.addSubview(tableView)
            containerView.addSubview(toView)

            UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut, animations: {
                fromBackgroundView.frame = containerView.bounds
                fromBackgroundView.layer.cornerRadius = 0
                tableView.frame.origin.y = CityDetailViewController.tableViewHeaderHeight() + 10
            }) { finished in
                if finished {
                    transitionContext.completeTransition(true)
                    toView.isHidden = false
                }
            }
        }
    }
}
