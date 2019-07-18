//
//  WeatherController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class WeatherController {
    var openWeatherAPIController: OpenWeatherAPIController?
    var databaseController: DatabaseController?
    var weatherDataFactory: WeatherDataFactory?
    typealias ForecastResult = ([ForecastModel], Error?) -> ()

    init(weatherAPIController: OpenWeatherAPIController, databaseController: DatabaseController, weatherDataFactory: WeatherDataFactory) {
        self.openWeatherAPIController = weatherAPIController
        self.databaseController = databaseController
        self.weatherDataFactory = weatherDataFactory
    }

    func fetchForecast(city: String, country: String, from: Date, type: String, completion: @escaping ForecastResult) {
        openWeatherAPIController?.requestForecast(city: city, country: country) { [weak self] (jsonData, error) in
            if let _ = error {
                let now = Date()
                self?.databaseController?.fetchIncomingForecasts(city: city, from: now, type: type) { (forecasts, error) in
                    if let error = error {
                        completion([], error)
                    }
                    else {
                        completion(forecasts, nil)
                    }
                }
            }
            else if let jsonData = jsonData {
                self?.databaseController?.cleanForecasts(city: city) {
                    self?.weatherDataFactory?.parseAndBuildForecastsFrom(jsonData: jsonData) { forecasts, error  in
                        if let error = error {
                            completion([], error)
                        }
                        else {
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
    }
}
