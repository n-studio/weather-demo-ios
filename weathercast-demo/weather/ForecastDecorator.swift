//
//  ForecastDecorator.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class ForecastDecorator {
    weak var forecast: ForecastModel?

    lazy private var weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "EEEE" // Monday, Tuesday, ...
        return formatter
    }()

    lazy private var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = timezone
        formatter.dateFormat = "HH:mm" // 02:00
        return formatter
    }()

    init(forecast: ForecastModel) {
        self.forecast = forecast
    }

    static func collection(_ collection: [ForecastModel]) -> [ForecastDecorator] {
        var decorators: [ForecastDecorator] = []
        for item in collection {
            let decorator = ForecastDecorator(forecast: item)
            decorator.compute()
            decorators.append(decorator)
        }
        return decorators
    }

    lazy var cityName: String = {
        return forecast?.cityName ?? ""
    }()

    lazy var temp: Float = {
        return forecast?.temp ?? 0
    }()

    func temperature(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(temp, unit: unit)
    }

    lazy var weather: String = {
        return forecast?.weatherDescription?.capitalizingFirstLetter() ?? ""
    }()

    lazy var weatherIconName: String? = {
        return forecast?.weatherIcon
    }()

    func weatherIcon(forceDayTime: Bool = false) -> UIImage? {
        guard let originalIconName = weatherIconName else { return nil }
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

    lazy var tempMin: Float = {
        return forecast?.tempMin ?? 0
    }()

    func temperatureMin(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(tempMin, unit: unit)
    }

    lazy var temperatureMinIcon: UIImage? = {
        let image = UIImage(imageLiteralResourceName: "tempMin")
        return image.withRenderingMode(.alwaysTemplate)
    }()

    lazy var tempMax: Float = {
        return forecast?.tempMax ?? 0
    }()

    func temperatureMax(unit: TempUnit) -> String {
        return TemperatureDecorator.convert(tempMax, unit: unit)
    }

    lazy var temperatureMaxIcon: UIImage? = {
        let image = UIImage(imageLiteralResourceName: "tempMax")
        return image.withRenderingMode(.alwaysTemplate)
    }()

    lazy var timezone: TimeZone = {
        return TimeZone(secondsFromGMT: Int(forecast?.cityTimezone ?? 0)) ?? TimeZone.current
    }()

    lazy var weekday: String = {
        guard let date = forecast?.date else { return "" }
        return weekdayFormatter.string(from: date)
    }()

    lazy var hour: String = {
        guard let date = forecast?.date else { return "" }
        return hourFormatter.string(from: date)
    }()

    func compute() {
        _ = timezone
        _ = hour
        _ = weekday
        _ = weather
        _ = temp
        _ = temperatureMaxIcon
        _ = tempMax
        _ = tempMin
        _ = weatherIconName
        _ = cityName
    }
}
