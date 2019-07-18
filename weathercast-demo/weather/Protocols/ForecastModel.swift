//
//  ForecastModel.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/19.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

protocol ForecastModel: class {
    var cityId: Int64 { get set }
    var cityIdentifier: String? { get set }
    var cityName: String? { get set }
    var cityTimezone: Int64 { get set }
    var cloudsAll: Float { get set }
    var createdAt: Date? { get set }
    var date: Date? { get set }
    var grndLevel: Float { get set }
    var humidity: Float { get set }
    var pressure: Float { get set }
    var rain3h: Float { get set }
    var seaLevel: Float { get set }
    var snow3h: Float { get set }
    var temp: Float { get set }
    var tempMax: Float { get set }
    var tempMin: Float { get set }
    var type: String? { get set }
    var weatherDescription: String? { get set }
    var weatherIcon: String? { get set }
    var weatherId: Int64 { get set }
    var weatherMain: String? { get set }
    var windDeg: Float { get set }
    var windSpeed: Float { get set }
}
