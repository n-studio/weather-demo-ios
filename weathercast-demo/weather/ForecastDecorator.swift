//
//  ForecastDecorator.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class ForecastDecorator {
    let forecast: Forecast

    init(forecast: Forecast) {
        self.forecast = forecast
    }

    func temperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast.temp, unit: unit)
    }

    func weather() -> String {
        return forecast.weatherMain ?? ""
    }

    func weatherIcon() -> UIImage? {
        guard let iconName = forecast.weatherIcon else { return nil }
        let image = UIImage(imageLiteralResourceName: iconName)
        return image.withRenderingMode(.alwaysTemplate)
    }

    func minTemperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast.tempMin, unit: unit)
    }

    func minTemperatureIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMin")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func maxTemperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast.tempMax, unit: unit)
    }

    func maxTemperatureIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMax")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func timezone() -> TimeZone {
        return TimeZone(secondsFromGMT: Int(forecast.cityTimezone)) ?? TimeZone.current
    }
}
