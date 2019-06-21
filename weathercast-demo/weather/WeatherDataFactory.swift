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
        var appDelegate: AppDelegate?
        DispatchQueue.main.sync {
            appDelegate = UIApplication.shared.delegate as? AppDelegate
        }
        guard let delegate = appDelegate else { fatalError("Error: Couldn't access appDelegate") }

        var forecasts: [Forecast] = []

        let managedContext = delegate.persistentContainer.viewContext
        guard let json = try! JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
            let list = json["list"] as? [[String: Any]] else { return forecasts }

        let city = json["city"] as? [String: Any]
        for day in list {
            let forecast = Forecast(context: managedContext)
            if let city = city {
                forecast.setValue(city["id"], forKeyPath: "city_id")
                forecast.setValue(city["name"], forKeyPath: "city_name")
            }
            if let main = day["main"] as? [String: Any] {
                forecast.setValue(main["temp"], forKeyPath: "temp")
                forecast.setValue(main["temp_max"], forKeyPath: "temp_max")
                forecast.setValue(main["temp_min"], forKeyPath: "temp_min")
                forecast.setValue(main["pressure"], forKeyPath: "pressure")
                forecast.setValue(main["sea_level"], forKeyPath: "sea_level")
                forecast.setValue(main["grnd_level"], forKeyPath: "grnd_level")
                forecast.setValue(main["humidity"], forKeyPath: "humidity")
            }
            if let weathers = day["weather"] as? [[String: Any]], let weather = weathers.first {
                forecast.setValue(weather["description"], forKeyPath: "weather_description")
                forecast.setValue(weather["icon"], forKeyPath: "weather_icon")
                forecast.setValue(weather["main"], forKeyPath: "weather_main")
            }
            if let clouds = day["clouds"] as? [String: Any] {
                forecast.setValue(clouds["all"], forKeyPath: "clouds_all")
            }
            if let date = day["dt"] as? Int {
                forecast.setValue(NSDate(timeIntervalSince1970: TimeInterval(date)), forKeyPath: "date")
            }
            if let rain = day["rain"] as? [String: Any] {
                forecast.setValue(rain["3h"], forKeyPath: "rain_3h")
            }
            if let snow = day["snow"] as? [String: Any] {
                forecast.setValue(snow["3h"], forKeyPath: "snow_3h")
            }
            if let wind = day["wind"] as? [String: Any] {
                forecast.setValue(wind["deg"], forKeyPath: "wind_deg")
                forecast.setValue(wind["speed"], forKeyPath: "wind_speed")
            }

            forecasts.append(forecast)
        }

        return forecasts
    }
}
