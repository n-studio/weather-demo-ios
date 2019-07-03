//
//  SeparatorBar.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class SeparatorBar: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()

        self.topRoundedCorners(cornerRadii: CGSize(width: 10, height: 10))
    }
}
