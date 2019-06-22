//
//  WeatherDataFactory.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit
import CoreData

struct Measurement {
    var temp: Float?
    var tempMax: Float?
    var tempMin: Float?
    var pressure: Float?
    var seaLevel: Float?
    var grndLevel: Float?
    var humidity: Float?
    var weatherDescription: String?
    var weatherIcon: String?
    var weatherMain: String?
    var cloudsAll: Float?
    var date: Date?
    var rain3h: Float?
    var snow3h: Float?
    var windDeg: Float?
    var windSpeed: Float?
}

class WeatherDataFactory {
    func parseAndBuildForecastsFrom(jsonData: Data) -> [Forecast] {
        var forecasts: [Forecast] = []

        let managedContext = CoreDataController.shared.persistentContainer.viewContext
        guard let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let list = json["list"] as? [[String: Any]] else { return forecasts }

        let city = json["city"] as? [String: Any]

        var groupedData: [[[String: Any]]] = []
        var calendar = Calendar.current
        if let cityTimezone = city?["timezone"] as? Int, let timezone = TimeZone(secondsFromGMT: cityTimezone) {
            calendar.timeZone = timezone
        }
        var previousDay: Int = 0

        // Group 3 hours data into 1 array per day
        for data in list {
            guard let date = data["dt"] as? Int else { continue }
            let currentDay = calendar.component(.day, from: Date(timeIntervalSince1970: TimeInterval(date)))
            if currentDay != previousDay {
                groupedData.append([])
                previousDay = currentDay
            }
            groupedData[groupedData.count - 1].append(data)
        }

        // Digest data into daily data
        var digestMeasurements: [Measurement] = []
        for dailyData in groupedData {
            var dailyMeasurement: [Measurement] = []
            for data in dailyData {
                var threeHoursMeasurement = Measurement()

                if let main = data["main"] as? [String: Any] {
                    threeHoursMeasurement.temp = (main["temp"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.tempMax = (main["temp_max"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.tempMin = (main["temp_min"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.pressure = (main["pressure"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.seaLevel = (main["sea_level"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.grndLevel = (main["grnd_level"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.humidity = (main["humidity"] as? NSNumber)?.floatValue
                }
                if let weathers = data["weather"] as? [[String: Any]], let weather = weathers.first {
                    threeHoursMeasurement.weatherDescription = weather["description"] as? String
                    threeHoursMeasurement.weatherIcon = weather["icon"] as? String
                    threeHoursMeasurement.weatherMain = weather["main"] as? String
                }
                if let clouds = data["clouds"] as? [String: Any] {
                    threeHoursMeasurement.cloudsAll = (clouds["all"] as? NSNumber)?.floatValue
                }
                if let date = data["dt"] as? Int {
                    threeHoursMeasurement.date = Date(timeIntervalSince1970: TimeInterval(date))
                }
                if let rain = data["rain"] as? [String: Any] {
                    threeHoursMeasurement.rain3h = (rain["3h"] as? NSNumber)?.floatValue
                }
                if let snow = data["snow"] as? [String: Any] {
                    threeHoursMeasurement.snow3h = (snow["3h"] as? NSNumber)?.floatValue
                }
                if let wind = data["wind"] as? [String: Any] {
                    threeHoursMeasurement.windDeg = (wind["deg"] as? NSNumber)?.floatValue
                    threeHoursMeasurement.windSpeed = (wind["speed"] as? NSNumber)?.floatValue
                }
                dailyMeasurement.append(threeHoursMeasurement)
            }
            digestMeasurements.append(digestThreeHoursMeasurementToDailyMeasurement(dailyMeasurement))
        }

        for dailyMeasurement in digestMeasurements {
            let forecast = Forecast(context: managedContext)
            guard let city = city else { continue }

            forecast.setValue(city["id"], forKeyPath: "cityId")
            forecast.setValue(city["name"], forKeyPath: "cityName")
            forecast.setValue(city["timezone"], forKeyPath: "cityTimezone")
            forecast.setValue(dailyMeasurement.temp, forKeyPath: "temp")
            forecast.setValue(dailyMeasurement.tempMax, forKeyPath: "tempMax")
            forecast.setValue(dailyMeasurement.tempMin, forKeyPath: "tempMin")
            forecast.setValue(dailyMeasurement.pressure, forKeyPath: "pressure")
            forecast.setValue(dailyMeasurement.seaLevel, forKeyPath: "seaLevel")
            forecast.setValue(dailyMeasurement.grndLevel, forKeyPath: "grndLevel")
            forecast.setValue(dailyMeasurement.humidity, forKeyPath: "humidity")
            forecast.setValue(dailyMeasurement.weatherDescription, forKeyPath: "weatherDescription")
            forecast.setValue(dailyMeasurement.weatherIcon, forKeyPath: "weatherIcon")
            forecast.setValue(dailyMeasurement.weatherMain, forKeyPath: "weatherMain")
            forecast.setValue(dailyMeasurement.cloudsAll, forKeyPath: "cloudsAll")
            forecast.setValue(dailyMeasurement.date, forKeyPath: "date")
            forecast.setValue(dailyMeasurement.rain3h, forKeyPath: "rain3h")
            forecast.setValue(dailyMeasurement.snow3h, forKeyPath: "snow3h")
            forecast.setValue(dailyMeasurement.windDeg, forKeyPath: "windDeg")
            forecast.setValue(dailyMeasurement.windSpeed, forKeyPath: "windSpeed")
            forecasts.append(forecast)
        }

        return forecasts
    }

    func digestThreeHoursMeasurementToDailyMeasurement(_ measurements: [Measurement]) -> Measurement {
        var measurement = Measurement()

        // Get first
        measurement.temp = measurements.first?.temp
        measurement.date = measurements.first?.date
        // Get min
        measurement.tempMin = measurements.filter({ m in m.tempMin != nil }).map({ m in m.tempMin! }).min()
        // Get max
        measurement.tempMax = measurements.filter({ m in m.tempMax != nil }).map({ m in m.tempMax! }).max()
        // Get average
        measurement.pressure = measurements.first?.pressure
        measurement.seaLevel = measurements.first?.seaLevel
        measurement.grndLevel = measurements.first?.grndLevel
        measurement.humidity = measurements.first?.humidity
        measurement.cloudsAll = measurements.first?.cloudsAll
        measurement.rain3h = measurements.first?.rain3h
        measurement.snow3h = measurements.first?.snow3h
        measurement.windDeg = measurements.first?.windDeg
        measurement.windSpeed = measurements.first?.windSpeed
        // Get worst
        measurement.weatherDescription = measurements.first?.weatherDescription
        measurement.weatherIcon = measurements.first?.weatherIcon
        measurement.weatherMain = measurements.first?.weatherMain

        return measurement
    }
}
