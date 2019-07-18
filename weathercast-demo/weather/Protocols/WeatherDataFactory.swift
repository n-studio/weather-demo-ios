//
//  WeatherDataFactory.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/19.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

protocol WeatherDataFactory {
    typealias ForecastResult = ([ForecastModel], Error?) -> ()

    func parseAndBuildForecastsFrom(jsonData: Data, completion: @escaping ForecastResult)
    func digestThreeHoursMeasurementToDailyMeasurement(_ measurements: [Measurement]) -> Measurement
}
