//
//  Float+extension.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/23.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

extension Float {
    func rounded(precision: Int) -> Float {
        let divisor = pow(10.0, Float(precision))
        return (self * divisor).rounded() / divisor
    }
}
