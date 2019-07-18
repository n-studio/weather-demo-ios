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

    static let cornerRadius: CGFloat = 20.0
    var timezone: TimeZone = TimeZone.current {
        didSet {
            clock?.stopClock()
            clock = Clock()
            clock?.timezone = timezone
            clock?.delegate = self
            clock?.startClock()
        }
    }
    var clock: Clock?

    var openPhotosApiController: OpenPhotosAPIController?
    var cityName: String? {
        didSet {
            if self.cityLabel?.text == cityName { return }
            guard let name = cityName else { return }
            self.cityLabel?.text = name
        }
    }

    var forecastDecorators: WeakArray<ForecastDecorator> = []

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setCellUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setShadowsUI()

        self.weekForecastView?.dataSource = self
        self.weekForecastView?.delegate = self

        reset()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        reset()
    }

    deinit {
        clock?.stopClock()
        clock = nil
    }

    private func reset() {
        (self.backgroundView as? UIImageView)?.image = nil
        self.cityLabel?.text = nil
        self.dateLabel?.text = nil
        self.timeLabel?.text = nil
        self.temperatureLabel?.text = nil
        self.weatherIcon?.image = nil
        self.weatherLabel?.text = nil
        self.temperatureMaxLabel?.text = nil
        self.temperatureMinLabel?.text = nil

        clock?.stopClock()
        self.clock = nil
    }
}

// MARK: UICollectionViewDataSource

extension CityOverviewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return [forecastDecorators.count - 1, 5].min() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayForecastCell",
                                                      for: indexPath) as! DayForecastCell
        cell.forecastDecorator = forecastDecorators[indexPath.row + 1]
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension CityOverviewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.size.height
        let width = height * 0.75
        return CGSize(width: width, height: height)
    }
}

// MARK: Clock

extension CityOverviewCell: ClockDelegate {
    func clockDidTick(dateString: String, timeString: String) {
        self.dateLabel?.text = dateString
        self.timeLabel?.text = timeString
    }
}

// MARK: BackgroundImage

extension CityOverviewCell {
    var backgroundImage: UIImage? {
        get {
            let imageView = self.backgroundView as? UIImageView
            return imageView?.image
        }
        set {
            let imageView = self.backgroundView as? UIImageView
            imageView?.image = newValue
        }
    }
}

// MARK: Set UI

extension CityOverviewCell {
    private func setCellUI() {
        self.backgroundColor = .clear

        self.contentView.layer.cornerRadius = CityOverviewCell.cornerRadius
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.shouldRasterize = true
        self.contentView.layer.rasterizationScale = UIScreen.main.scale

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = CityOverviewCell.cornerRadius
        imageView.layer.masksToBounds = true
        imageView.layer.backgroundColor = UIColor.black.cgColor
        imageView.layer.add(transition, forKey: kCATransition)
        imageView.layer.shouldRasterize = true
        imageView.layer.rasterizationScale = UIScreen.main.scale
        self.backgroundView = imageView
    }

    private func setShadowsUI() {
        self.contentView.addShadowToSubviews()
        self.temperatureMaxMinStackView?.addShadowToSubviews()
    }

    func reload() {
        if self.forecastDecorators.count <= 0 {
            return
        }
        guard let todayForecastDecorator = self.forecastDecorators.first else { return }

        self.timezone = todayForecastDecorator.timezone
        DispatchQueue.main.async {
            self.temperatureLabel?.text = todayForecastDecorator.temperature(unit: .metric)
            self.weatherLabel?.text = todayForecastDecorator.weather
            self.weatherIcon?.image = todayForecastDecorator.weatherIcon()
            self.temperatureMinIcon?.image = todayForecastDecorator.temperatureMinIcon
            self.temperatureMinLabel?.text = todayForecastDecorator.temperatureMin(unit: .metric)
            self.temperatureMaxIcon?.image = todayForecastDecorator.temperatureMaxIcon
            self.temperatureMaxLabel?.text = todayForecastDecorator.temperatureMax(unit: .metric)

            self.weekForecastView?.reloadData()
        }
    }
}
