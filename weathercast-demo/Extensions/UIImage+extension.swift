//
//  UIImage+extension.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/16.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

extension UIImage {
    func alpha(_ value: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
