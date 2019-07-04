//
//  CityDetailViewController+DataSource.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: UITableViewDataSource

extension CityDetailViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groupedForecastDecorators.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let forecastDecorator = self.groupedForecastDecorators[section].first {
            return forecastDecorator.weekday
        }
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupedForecastDecorators[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell",
                                                 for: indexPath) as! HourlyWeatherCell
        let forecastDecorator = self.groupedForecastDecorators[indexPath.section][indexPath.row]
        cell.hourLabel?.text = forecastDecorator.hour
        cell.weatherIcon?.image = forecastDecorator.weatherIcon(forceDayTime: true)
        cell.tempMaxLabel?.text = forecastDecorator.temperatureMax(unit: .metric)
        cell.tempMinLabel?.text = forecastDecorator.temperatureMin(unit: .metric)

        return cell
    }
}
