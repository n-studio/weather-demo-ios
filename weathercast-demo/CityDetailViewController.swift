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

// MARK: UI Setup

extension CityDetailViewController {
    private func setTableViewHeaderUI() {
        self.tableView.tableHeaderView?.addShadowToSubviews()
    }

    func setOutletsUI() {
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

// MARK: Actions

extension CityDetailViewController {
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
