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
        for view in self.subviews {
            if view is UILabel || view is UIImageView {
                view.layer.shadowColor = color.cgColor
                view.layer.shadowOffset = offset
                view.layer.shadowRadius = radius
                view.layer.shadowOpacity = opacity
                view.layer.masksToBounds = false
            }
        }
    }
}
