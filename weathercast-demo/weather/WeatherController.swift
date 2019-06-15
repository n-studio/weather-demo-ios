//
//  WeatherController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class WeatherController {
    let openAPIController = OpenAPIController()
    let coreDataController = CoreDataController()
    let weatherDataFactory = WeatherDataFactory()

    func fetchForecast(completion: @escaping () -> ()) {
        openAPIController.requestForecast(zipcode: "75000", country: "fr", completion: { jsonString in
            let forecast = self.weatherDataFactory.parseAndCreateForecastFrom(json: jsonString)
            self.coreDataController.saveToDatabase(forecast)
            completion()
        })
    }
}
