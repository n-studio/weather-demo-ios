//
//  WeatherController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class WeatherController {
    let openWeatherAPIController = OpenWeatherAPIController()
    let coreDataController = CoreDataController.shared
    let weatherDataFactory = WeatherDataFactory()
    typealias ForecastResult = ([Forecast], Error?) -> ()

    func fetchForecast(city: String, country: String, from: Date, completion: @escaping ForecastResult) {
        openWeatherAPIController.requestForecast(city: city, country: country) { [weak self] (jsonData, error) in
            if let _ = error {
                let now = Date()
                self?.coreDataController.fetchIncomingForecasts(city: city, from: now) { (forecasts, error) in
                    if let error = error {
                        completion([], error)
                    }
                    else {
                        completion(forecasts, nil)
                    }
                }
            }
            else if let jsonData = jsonData {
                self?.coreDataController.cleanForecasts(city: city) {
                    guard let forecasts = self?.weatherDataFactory.parseAndBuildForecastsFrom(jsonData: jsonData) else {
                        completion([], UnknownError.withMessage(string: "[fetchForecast] Unkown Error"))
                        return
                    }
                    self?.coreDataController.save()

                    let incomingForecasts = forecasts.filter() { (forecast) -> Bool in
                        if let data = forecast.date {
                            return data >= from
                        }
                        return false
                    }
                    completion(incomingForecasts, nil)
                }
            }
        }
    }
}
