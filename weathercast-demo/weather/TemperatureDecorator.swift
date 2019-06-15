//
//  TemperatureUnitConvertor.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class TemperatureDecorator {
    class func metric(_ temperatureInKelvin: Float) -> String {
        return "°C"
    }
    
    class func imperial(_ temperatureInKelvin: Float) -> String {
        return "°F"
    }
    
    class func kelvin(_ temperatureInKelvin: Float) -> String {
        return "\(temperatureInKelvin.rounded()) K"
    }
}
