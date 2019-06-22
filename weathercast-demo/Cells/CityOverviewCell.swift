//
//  CityOverviewCell.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit
import WeakArray

class CityOverviewCell: UICollectionViewCell {
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var maxTemperatureIcon: UIImageView!
    @IBOutlet var maxTemperatureLabel: UILabel!
    @IBOutlet var minTemperatureIcon: UIImageView!
    @IBOutlet var minTemperatureLabel: UILabel!
    @IBOutlet var weekForecastView: UICollectionView!

    let cornerRadius: CGFloat = 20.0
    var timer: Timer?

    lazy var timezone: TimeZone = {
        return TimeZone.current
    }()

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = timezone
        return formatter
    }()

    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timezone
        return formatter
    }()

    let openPhotosApiController = OpenPhotosAPIController()
    var cityName: String? {
        didSet {
            guard let name = cityName else { return }
            self.cityLabel.text = name
            openPhotosApiController.searchPhoto(query: name) { (urlString) in
                self.openPhotosApiController.getPhoto(urlString: urlString) { (image) in
                    DispatchQueue.main.async {
                        let imageView = UIImageView(image: image.alpha(0.8))
                        imageView.contentMode = .scaleAspectFill
                        imageView.layer.cornerRadius = self.cornerRadius
                        imageView.layer.masksToBounds = true
                        self.backgroundView = imageView
                    }
                }
            }
        }
    }

    var forecasts: WeakArray<Forecast> = [] {
        didSet {
            if self.forecasts.count <= 0 {
                return
            }
            guard let todayForecast = self.forecasts.first else { return }

            let todayForecastDecorator = ForecastDecorator(forecast: todayForecast)
            self.timezone = todayForecastDecorator.timezone()
            self.temperatureLabel?.text = todayForecastDecorator.temperature(unit: .metric)
            self.weatherLabel.text = todayForecastDecorator.weather()
            self.weatherIcon.image = todayForecastDecorator.weatherIcon()
            self.minTemperatureIcon.image = todayForecastDecorator.minTemperatureIcon()
            self.minTemperatureLabel?.text = todayForecastDecorator.minTemperature(unit: .metric)
            self.maxTemperatureIcon.image = todayForecastDecorator.maxTemperatureIcon()
            self.maxTemperatureLabel?.text = todayForecastDecorator.maxTemperature(unit: .metric)

            self.weekForecastView.reloadData()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .clear

        self.contentView.layer.cornerRadius = cornerRadius
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        for view in self.contentView.subviews {
            if view is UILabel || view is UIImageView {
                view.layer.shadowColor = UIColor.black.cgColor
                view.layer.shadowOffset = CGSize(width: 0, height: 0)
                view.layer.shadowRadius = 3.0
                view.layer.shadowOpacity = 1.0
                view.layer.masksToBounds = false
            }
        }
        self.minTemperatureIcon.tintColor = .white
        self.maxTemperatureIcon.tintColor = .white
        self.weatherIcon.tintColor = .white

        self.weekForecastView.dataSource = self

        startClock()
    }

    deinit {
        stopClock()
    }
}

// MARK: Clock

extension CityOverviewCell {
    func startClock() {
        tickClock()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(tickClock), userInfo: nil, repeats: true)
    }

    func stopClock() {
        timer?.invalidate()
    }

    @objc func tickClock() {
        let date = Date()
        self.dateLabel.text = dateFormatter.string(from: date)
        self.timeLabel.text = timeFormatter.string(from: date)
    }
}

// MARK: UICollectionViewDataSource

extension CityOverviewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecasts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayForecastCell", for: indexPath) as! DayForecastCell
        cell.forecast = forecasts[indexPath.row]
        return cell
    }
}
