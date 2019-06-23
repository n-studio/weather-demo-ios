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

    lazy private var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday, Tuesday, ...
        return formatter
    }()

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

    func temperatureMin(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast.tempMin, unit: unit)
    }

    func temperatureMinIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMin")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func temperatureMax(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast.tempMax, unit: unit)
    }

    func temperatureMaxIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMax")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func timezone() -> TimeZone {
        return TimeZone(secondsFromGMT: Int(forecast.cityTimezone)) ?? TimeZone.current
    }

    func weekday() -> String {
        guard let date = forecast.date else { return "" }
        return weekdayFormatter.string(from: date)
    }
}
