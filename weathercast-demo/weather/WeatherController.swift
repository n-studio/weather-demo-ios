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

    func fetchForecast(city: String, country: String, completion: @escaping (_ forecasts: [Forecast]) -> ()) {
        openWeatherAPIController.requestForecast(city: city, country: country) { [weak self] (jsonData) in
            guard let forecasts = self?.weatherDataFactory.parseAndBuildForecastsFrom(jsonData: jsonData) else { return }
            self?.coreDataController.save()
            completion(forecasts)
        }
    }
}
