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
            resetClock()
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
            self.groupedForecastDecorators = []
            self.disableClock()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setTableViewHeaderUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setOutletsUI()
        fetchData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
}

// MARK: UI Setup

extension CityDetailViewController {
    private func setTableViewHeaderUI() {
        self.tableView.tableHeaderView?.addShadowToSubviews()
        switch deviceSize {
        case .i3_5Inch, .i4Inch:
            self.tableView.tableHeaderView?.frame.size.height = 210
        default:
            self.tableView.tableHeaderView?.frame.size.height = 260
        }

        self.backButton?.addShadow()
    }

    func setOutletsUI() {
        guard let firstForecastDecorator = groupedForecastDecorators.first?.first else { return }
        let forecastDecorator = firstForecastDecorator
        self.timezone = forecastDecorator.timezone
        self.cityLabel?.text = forecastDecorator.cityName
    }

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: Actions

extension CityDetailViewController {
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
