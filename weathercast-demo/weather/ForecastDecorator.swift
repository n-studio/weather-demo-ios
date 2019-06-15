//
//  ForecastDecorator.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class ForecastDecorator {
    let forecast: Forecast

    init(forecast: Forecast) {
        self.forecast = forecast
    }

    func temperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(20, unit: unit)
    }
}
