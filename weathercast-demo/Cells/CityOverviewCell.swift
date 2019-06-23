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
    @IBOutlet var temperatureMaxIcon: UIImageView!
    @IBOutlet var temperatureMaxLabel: UILabel!
    @IBOutlet var temperatureMinIcon: UIImageView!
    @IBOutlet var temperatureMinLabel: UILabel!
    @IBOutlet var weekForecastView: UICollectionView!

    let cornerRadius: CGFloat = 20.0
    var timezone: TimeZone = TimeZone.current {
        didSet {
            clock?.timezone = timezone
        }
    }
    var clock: Clock? = Clock()

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
            self.temperatureMinIcon.image = todayForecastDecorator.temperatureMinIcon()
            self.temperatureMinLabel?.text = todayForecastDecorator.temperatureMin(unit: .metric)
            self.temperatureMaxIcon.image = todayForecastDecorator.temperatureMaxIcon()
            self.temperatureMaxLabel?.text = todayForecastDecorator.temperatureMax(unit: .metric)

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

        self.contentView.addShadow()

        self.weekForecastView.dataSource = self

        clock?.delegate = self
        clock?.startClock()
    }

    deinit {
        clock?.stopClock()
        clock = nil
    }
}

// MARK: UICollectionViewDataSource

extension CityOverviewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return [forecasts.count - 1, 5].min() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayForecastCell",
                                                      for: indexPath) as! DayForecastCell
        cell.forecast = forecasts[indexPath.row + 1]
        return cell
    }
}

// MARK: Clock

extension CityOverviewCell: ClockDelegate {
    func clockDidTick(dateString: String, timeString: String) {
        self.dateLabel.text = dateString
        self.timeLabel.text = timeString
    }
}
