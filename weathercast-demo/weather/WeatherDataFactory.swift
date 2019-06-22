//
//  WeatherDataFactory.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit
import CoreData

class WeatherDataFactory {
    func parseAndBuildForecastsFrom(jsonData: Data) -> [Forecast] {
        var forecasts: [Forecast] = []

        let managedContext = CoreDataController.shared.persistentContainer.viewContext
        guard let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let list = json["list"] as? [[String: Any]] else { return forecasts }

        let city = json["city"] as? [String: Any]
        for day in list {
            let forecast = Forecast(context: managedContext)
            if let city = city {
                forecast.setValue(city["id"], forKeyPath: "cityId")
                forecast.setValue(city["name"], forKeyPath: "cityName")
                forecast.setValue(city["timezone"], forKeyPath: "cityTimezone")
            }
            if let main = day["main"] as? [String: Any] {
                forecast.setValue(main["temp"], forKeyPath: "temp")
                forecast.setValue(main["temp_max"], forKeyPath: "tempMax")
                forecast.setValue(main["temp_min"], forKeyPath: "tempMin")
                forecast.setValue(main["pressure"], forKeyPath: "pressure")
                forecast.setValue(main["sea_level"], forKeyPath: "seaLevel")
                forecast.setValue(main["grnd_level"], forKeyPath: "grndLevel")
                forecast.setValue(main["humidity"], forKeyPath: "humidity")
            }
            if let weathers = day["weather"] as? [[String: Any]], let weather = weathers.first {
                forecast.setValue(weather["description"], forKeyPath: "weatherDescription")
                forecast.setValue(weather["icon"], forKeyPath: "weatherIcon")
                forecast.setValue(weather["main"], forKeyPath: "weatherMain")
            }
            if let clouds = day["clouds"] as? [String: Any] {
                forecast.setValue(clouds["all"], forKeyPath: "cloudsAll")
            }
            if let date = day["dt"] as? Int {
                forecast.setValue(NSDate(timeIntervalSince1970: TimeInterval(date)), forKeyPath: "date")
            }
            if let rain = day["rain"] as? [String: Any] {
                forecast.setValue(rain["3h"], forKeyPath: "rain3h")
            }
            if let snow = day["snow"] as? [String: Any] {
                forecast.setValue(snow["3h"], forKeyPath: "snow3h")
            }
            if let wind = day["wind"] as? [String: Any] {
                forecast.setValue(wind["deg"], forKeyPath: "windDeg")
                forecast.setValue(wind["speed"], forKeyPath: "windSpeed")
            }

            forecasts.append(forecast)
        }

        return forecasts
    }
}
