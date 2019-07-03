//
//  CityDetailViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/22.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CityDetailViewController: UITableViewController {
    var clock: Clock?
    var timezone: TimeZone = TimeZone.current {
        didSet {
            clock?.stopClock()
            clock = Clock()
            clock?.timezone = timezone
            clock?.delegate = self
            clock?.startClock()
        }
    }
    var cityName: String?
    var groupedForecastDecorators: [[ForecastDecorator]] = []

    @IBOutlet var backButton: UIButton?
    @IBOutlet var cityLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var separatorBar: UIView?

    @IBAction func dismiss(_ sender: Any) {
        self.groupedForecastDecorators = []
        self.dismiss(animated: true) {
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setTableViewHeaderUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSeparatorBarUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setOutletsUI()
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    deinit {
        clock?.stopClock()
        clock = nil
    }
}

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

//        cell.layer.shouldRasterize = true

        return cell
    }
}

// MARK: Actions

extension CityDetailViewController {
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Clock

extension CityDetailViewController: ClockDelegate {
    func clockDidTick(dateString: String, timeString: String) {
        DispatchQueue.main.async {
            self.dateLabel?.text = dateString
            self.timeLabel?.text = timeString
        }
    }
}

// MARK: UI Setup

extension CityDetailViewController {
    private func setTableViewHeaderUI() {
        self.tableView.tableHeaderView?.addShadowToSubviews()
    }

    private func setOutletsUI() {
        guard let firstForecastDecorator = groupedForecastDecorators.first?.first else { return }
        let forecastDecorator = firstForecastDecorator
        self.timezone = forecastDecorator.timezone
        self.cityLabel?.text = forecastDecorator.cityName
    }

    private func setSeparatorBarUI() {
        self.separatorBar?.topRoundedCorners(cornerRadii: CGSize(width: 10, height: 10))
        self.separatorBar?.addShadow(offset: CGSize(width: 0, height: -10))
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: Fetch data

extension CityDetailViewController {
    func fetchData() {
        // Fetch data for all cities
        let now = Date()
        guard let city = cityName else { return }

        let serialQueue = DispatchQueue(label: "coredata", qos: .background)
        serialQueue.async {
            let coreDataController = CoreDataController.shared
            coreDataController.fetchIncomingForecasts(city: city, from: now, type: "3hourly") { (forecasts, error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                }
                else {
                    DispatchQueue.main.async {
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
                        self.setOutletsUI()
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
