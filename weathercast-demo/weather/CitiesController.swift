//
//  CitiesController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/21.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

struct City {
    var name: String
    var country: String
    var forecastDecorators: [ForecastDecorator]?
}

class CitiesController {
    lazy var cities: [City] = {
        return [
            City(name: "Paris", country: "fr", forecastDecorators: nil),
            City(name: "London", country: "gb", forecastDecorators: nil),
            City(name: "Tokyo", country: "jp", forecastDecorators: nil)
        ]
    }()
}
