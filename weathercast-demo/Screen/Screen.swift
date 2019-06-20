//
//  Screen.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/20.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class Screen {
    let bounds: CGRect

    init(view: UIView) {
        if #available(iOS 11.0, *) {
            self.bounds = CGRect(x: 0, y: 0, width: view.bounds.width - view.safeAreaInsets.left - view.safeAreaInsets.right, height: view.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom)
        } else {
            self.bounds = view.bounds
        }
    }

    lazy var aspectRatio: CGFloat = {
        return self.bounds.width / self.bounds.height
    }()

    lazy var width: CGFloat = {
        return self.bounds.width
    }()
}
