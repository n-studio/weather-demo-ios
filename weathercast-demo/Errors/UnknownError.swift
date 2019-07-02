//
//  UnknownError.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/02.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

enum UnknownError: Error {
    case withMessage(string: String)
}

extension UnknownError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .withMessage(string: let string):
            return NSLocalizedString(string, comment: "Unkown error")
        }
    }
}
