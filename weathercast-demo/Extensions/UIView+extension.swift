//
//  UIView+extension.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/23.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

extension UIView {
    func addShadow(opacity: Float = 1.0, radius: CGFloat = 3.0, offset: CGSize = .zero, color: UIColor = .black) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    func addShadowToSubviews(opacity: Float = 1.0, radius: CGFloat = 3.0, offset: CGSize = .zero, color: UIColor = .black) {
        for view in self.subviews {
            if view is UILabel || view is UIImageView {
                view.layer.shadowColor = color.cgColor
                view.layer.shadowOffset = offset
                view.layer.shadowRadius = radius
                view.layer.shadowOpacity = opacity
                view.layer.masksToBounds = false
                view.layer.shouldRasterize = true
                view.layer.rasterizationScale = UIScreen.main.scale
            }
        }
    }

    func topRoundedCorners(cornerRadii: CGSize = CGSize(width: 10, height: 10)) {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: cornerRadii).cgPath
        self.layer.mask = maskLayer
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
