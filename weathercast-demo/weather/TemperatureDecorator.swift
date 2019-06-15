//
//  TemperatureUnitConvertor.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

enum TempUnit {
    case Kelvin
    case Metric
    case Imperial
}

class TemperatureDecorator {
    class func convert(_ temperatureInKelvin: Float, unit: TempUnit) -> String {
        switch unit {
        case .Metric:
            return "\(Int(round(temperatureInKelvin - 273.15))) °C"
        case .Imperial:
            return "\(Int(round(temperatureInKelvin * 9.0 / 5.0 - 459.67))) °F"
        default:
            return "\(Int(round(temperatureInKelvin))) K"
        }
    }
}
