//
//  DatabaseController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/19.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

protocol DatabaseController {
    typealias ForecastResult = ([ForecastModel], Error?) -> ()

    func fetchIncomingForecasts(city: String, from: Date, type: String, completion: @escaping ForecastResult)
    func fetchForecasts(predicate: NSPredicate, completion: @escaping ForecastResult)
    func cleanForecasts(city: String, completion: @escaping () -> ())
}
