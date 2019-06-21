//
//  TemperatureUnitConvertor.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

enum TempUnit {
    case kelvin
    case metric
    case imperial
}

class TemperatureDecorator {
    class func convert(_ temperatureInKelvin: Float, unit: TempUnit) -> String {
        switch unit {
        case .metric:
            return "\(Int(round(temperatureInKelvin - 273.15)))℃"
        case .imperial:
            return "\(Int(round(temperatureInKelvin * 9.0 / 5.0 - 459.67)))℉"
        default:
            return "\(Int(round(temperatureInKelvin)))K"
        }
    }
}
