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
    var forecasts: [Forecast] = []

    @IBOutlet var backButton: UIButton?
    @IBOutlet var cityLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var separatorBar: UIView?

    @IBAction func dismiss(_ sender: Any) {
        forecasts = []
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecasts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HourlyWeatherCell",
                                                 for: indexPath) as! HourlyWeatherCell

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
        self.dateLabel?.text = dateString
        self.timeLabel?.text = timeString
    }
}

// MARK: UI Setup

extension CityDetailViewController {
    private func setTableViewHeaderUI() {
        self.tableView.tableHeaderView?.addShadowToSubviews()
    }

    private func setOutletsUI() {
        guard let firstForecast = forecasts.first else { return }
        let forecastDecorator = ForecastDecorator(forecast: firstForecast)
        self.timezone = forecastDecorator.timezone()
        self.cityLabel?.text = forecastDecorator.cityName()
    }

    private func setSeparatorBarUI() {
        self.separatorBar?.topRoundedCorners(cornerRadii: CGSize(width: 10, height: 10))
        self.separatorBar?.addShadow(offset: CGSize(width: 0, height: -10))
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}
