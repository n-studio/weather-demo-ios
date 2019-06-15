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
    let coreDataController = CoreDataController()
    let weatherDataFactory = WeatherDataFactory()

    func fetchForecast(completion: @escaping (_ forecasts: [Forecast]) -> ()) {
        openWeatherAPIController.requestForecast(zipcode: "75000", country: "fr") { jsonData in
            DispatchQueue.main.async {
                let forecasts = self.weatherDataFactory.parseAndBuildForecastsFrom(jsonData: jsonData)
                self.coreDataController.save()
                completion(forecasts)
            }
        }
    }
}
