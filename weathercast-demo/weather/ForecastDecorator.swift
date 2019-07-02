//
//  ForecastDecorator.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class ForecastDecorator {
    weak var forecast: Forecast?

    lazy private var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE" // Monday, Tuesday, ...
        return formatter
    }()

    init(forecast: Forecast) {
        self.forecast = forecast
    }

    func cityName() -> String {
        return forecast?.cityName ?? ""
    }

    func temperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast?.temp ?? 0, unit: unit)
    }

    func weather() -> String {
        return forecast?.weatherDescription?.capitalizingFirstLetter() ?? ""
    }

    func weatherIcon(forceDayTime: Bool = false) -> UIImage? {
        guard let originalIconName = forecast?.weatherIcon else { return nil }
        let iconName: String
        if forceDayTime {
            // Convert night to day
            iconName = originalIconName.replacingOccurrences(of: "n", with: "d")
        }
        else {
            iconName = originalIconName
        }
        let image = UIImage(imageLiteralResourceName: iconName)
        return image.withRenderingMode(.alwaysTemplate)
    }

    func temperatureMin(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast?.tempMin ?? 0, unit: unit)
    }

    func temperatureMinIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMin")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func temperatureMax(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(forecast?.tempMax ?? 0, unit: unit)
    }

    func temperatureMaxIcon() -> UIImage? {
        let image = UIImage(imageLiteralResourceName: "tempMax")
        return image.withRenderingMode(.alwaysTemplate)
    }

    func timezone() -> TimeZone {
        return TimeZone(secondsFromGMT: Int(forecast?.cityTimezone ?? 0)) ?? TimeZone.current
    }

    func weekday() -> String {
        guard let date = forecast?.date else { return "" }
        return weekdayFormatter.string(from: date)
    }
}
