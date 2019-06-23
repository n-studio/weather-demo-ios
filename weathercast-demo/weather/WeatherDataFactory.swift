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
    var weatherId: Int?
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
                    threeHoursMeasurement.weatherId = (weather["id"] as? NSNumber)?.intValue
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
            forecast.setValue(dailyMeasurement.weatherId, forKeyPath: "weatherId")
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
        measurement.pressure = measurements.map({ m in m.pressure ?? 0 }).average()
        measurement.seaLevel = measurements.map({ m in m.seaLevel ?? 0 }).average()
        measurement.grndLevel = measurements.map({ m in m.grndLevel ?? 0 }).average()
        measurement.humidity = measurements.map({ m in m.humidity ?? 0 }).average()
        measurement.cloudsAll = measurements.map({ m in m.cloudsAll ?? 0 }).average()
        measurement.rain3h = measurements.map({ m in m.rain3h ?? 0 }).average()
        measurement.snow3h = measurements.map({ m in m.snow3h ?? 0 }).average()
        measurement.windDeg = measurements.map({ m in m.windDeg ?? 0 }).average()
        measurement.windSpeed = measurements.map({ m in m.windSpeed ?? 0 }).average()
        // Get the worst of the day
        if let worstMeasurement = getWorstWeatherMeasurement(measurements: measurements) {
            measurement.weatherId = worstMeasurement.weatherId
            measurement.weatherDescription = worstMeasurement.weatherDescription
            measurement.weatherIcon = worstMeasurement.weatherIcon
            measurement.weatherMain = worstMeasurement.weatherMain
        }

        return measurement
    }

    // https://openweathermap.org/weather-conditions
    let worstWeatherOrder = [
        800,  //    Clear       clear sky                    01d 01n
        801, //     Clouds      few clouds: 11-25%           02d 02n
        802, //     Clouds      scattered clouds: 25-50%     03d 03n
        803, //     Clouds      broken clouds: 51-84%        04d 04n
        804, //     Clouds      overcast clouds: 85-100%     04d 04n
        300, //     Drizzle     light intensity drizzle          09d
        301, //     Drizzle     drizzle                          09d
        302, //     Drizzle     heavy intensity drizzle          09d
        310, //     Drizzle     light intensity drizzle rain     09d
        311, //     Drizzle     drizzle rain                     09d
        312, //     Drizzle     heavy intensity drizzle rain     09d
        313, //     Drizzle     shower rain and drizzle          09d
        314, //     Drizzle     heavy shower rain and drizzle    09d
        321, //     Drizzle     shower drizzle                   09d
        701, //     Mist     mist                  50d
        711, //     Smoke    Smoke                 50d
        721, //     Haze     Haze                  50d
        731, //     Dust     sand/ dust whirls     50d
        741, //     Fog      fog                   50d
        751, //     Sand     sand                  50d
        761, //     Dust     dust                  50d
        500, //     Rain     light rain                      10d
        501, //     Rain     moderate rain                   10d
        502, //     Rain     heavy intensity rain            10d
        503, //     Rain     very heavy rain                 10d
        504, //     Rain     extreme rain                    10d
        511, //     Rain     freezing rain                   13d
        520, //     Rain     light intensity shower rain     09d
        521, //     Rain     shower rain                     09d
        522, //     Rain     heavy intensity shower rain     09d
        531, //     Rain     ragged shower rain              09d
        200, //     Thunderstorm     thunderstorm with light rain     11d
        201, //     Thunderstorm     thunderstorm with rain           11d
        202, //     Thunderstorm     thunderstorm with heavy rain     11d
        210, //     Thunderstorm     light thunderstorm               11d
        211, //     Thunderstorm     thunderstorm                     11d
        212, //     Thunderstorm     heavy thunderstorm               11d
        221, //     Thunderstorm     ragged thunderstorm              11d
        230, //     Thunderstorm     thunderstorm with light drizzle  11d
        231, //     Thunderstorm     thunderstorm with drizzle        11d
        232, //     Thunderstorm     thunderstorm with heavy drizzle  11d
        600, //     Snow     light snow            13d
        601, //     Snow     Snow                  13d
        602, //     Snow     Heavy snow            13d
        611, //     Snow     Sleet                 13d
        612, //     Snow     Light shower sleet    13d
        613, //     Snow     Shower sleet          13d
        615, //     Snow     Light rain and snow   13d
        616, //     Snow     Rain and snow         13d
        620, //     Snow     Light shower snow     13d
        621, //     Snow     Shower snow           13d
        622, //     Snow     Heavy shower snow     13d
        762, //     Ash         volcanic ash     50d
        771, //     Squall      squalls          50d
        781  //     Tornado     tornado          50d
    ]

    private func getWorstWeatherMeasurement(measurements: [Measurement]) -> Measurement? {
        var worstMeasurement: Measurement?
        for measurement in measurements {
            guard let _ = worstMeasurement else {
                worstMeasurement = measurement
                continue
            }
            guard let weatherId = measurement.weatherId, let worstWeatherId = worstMeasurement?.weatherId else { continue }
            let currentIndex = worstWeatherOrder.firstIndex(of: weatherId) ?? -1
            let worstIndex = worstWeatherOrder.firstIndex(of: worstWeatherId) ?? -1
            if currentIndex > worstIndex {
                worstMeasurement = measurement
            }
        }
        return worstMeasurement
    }
}
