//
//  Array+extension.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/23.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

extension Collection where Element: Numeric {
    var total: Element { return reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    func average() -> Float {
        return isEmpty ? 0 : Float(total) / Float(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    func average() -> Element {
        return isEmpty ? 0 : total / Element(count)
    }
}
