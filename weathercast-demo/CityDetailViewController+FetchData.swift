//
//  CityDetailViewController+FetchData.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: Fetch data

extension CityDetailViewController {
    func fetchData() {
        // Fetch data for all cities
        let now = Date()
        guard let city = cityName else { return }

        let coreDataController = CoreDataController.shared
        coreDataController.fetchIncomingForecasts(city: city, from: now, type: "3hourly") { (forecasts, error) in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            else {
                var currentWeekDay: String = ""
                for forecast in forecasts {
                    let decorator = ForecastDecorator(forecast: forecast)
                    decorator.compute()
                    if currentWeekDay != decorator.weekday {
                        self.groupedForecastDecorators.append([])
                        currentWeekDay = decorator.weekday
                    }
                    self.groupedForecastDecorators[self.groupedForecastDecorators.count - 1].append(decorator)
                }
                DispatchQueue.main.async {
                    self.setOutletsUI()
                    self.tableView.reloadData()
                }
            }
        }
    }
}
