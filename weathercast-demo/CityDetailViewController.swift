//
//  CityDetailViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/22.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {
    @IBOutlet var backButton: UIButton?
    @IBOutlet var cityLabel: UILabel?
    @IBOutlet var dateLabel: UILabel?
    @IBOutlet var timeLabel: UILabel?
    @IBOutlet var temperatureLabel: UILabel?
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet var weatherLabel: UILabel?
    @IBOutlet var temperatureMaxMinStackView: UIStackView?
    @IBOutlet var temperatureMaxIcon: UIImageView?
    @IBOutlet var temperatureMaxLabel: UILabel?
    @IBOutlet var temperatureMinIcon: UIImageView?
    @IBOutlet var temperatureMinLabel: UILabel?
    @IBOutlet var weekForecastView: UICollectionView?

    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    var forecasts: [Forecast] = []
    var currentWeather: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton?.addTarget(self, action: #selector(back), for: .touchDown)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
