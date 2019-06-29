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

    @IBOutlet var backButton: UIButton?
    @IBOutlet var cityLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var temperatureLabel: UILabel?
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet var weatherLabel: UILabel?
    @IBOutlet var temperatureMaxIcon: UIImageView?
    @IBOutlet var temperatureMaxLabel: UILabel?
    @IBOutlet var temperatureMinIcon: UIImageView?
    @IBOutlet var temperatureMinLabel: UILabel?

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var forecasts: [Forecast] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton?.addTarget(self, action: #selector(back), for: .touchDown)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setOutlets()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    deinit {
        clock?.stopClock()
        clock = nil
    }
}

// MARK: Forecast

extension CityDetailViewController {
    private func setOutlets() {
        guard let firstForecast = forecasts.first else { return }
        let forecastDecorator = ForecastDecorator(forecast: firstForecast)
        self.timezone = forecastDecorator.timezone()
        self.cityLabel?.text = forecastDecorator.cityName()
        self.temperatureLabel?.text = forecastDecorator.temperature(unit: .metric)
        self.weatherIcon?.image = forecastDecorator.weatherIcon()
        self.weatherLabel?.text = forecastDecorator.weather()
        self.temperatureMaxLabel?.text = forecastDecorator.temperatureMax(unit: .metric)
        self.temperatureMaxIcon?.image = forecastDecorator.temperatureMaxIcon()
        self.temperatureMinLabel?.text = forecastDecorator.temperatureMin(unit: .metric)
        self.temperatureMinIcon?.image = forecastDecorator.temperatureMinIcon()
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
        self.dateLabel?.text = dateString
        self.timeLabel?.text = timeString
    }
}
