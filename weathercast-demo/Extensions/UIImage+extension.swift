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
        defer { UIGraphicsEndImageContext() }
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        return newImage!
    }

    convenience init?(view: UIView) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let currentImage = UIGraphicsGetImageFromCurrentImageContext()

        guard let image = currentImage, let cgImage = image.cgImage else { return nil }
        self.init(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
