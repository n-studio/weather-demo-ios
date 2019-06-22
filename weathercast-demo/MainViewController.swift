//
//  ViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {
    let weatherController = WeatherController()
    let minimumLineSpacing: CGFloat = 88.0
    let cellMargins = CGSize(width: 20, height: 88.0)
    var cities: [City]

    lazy var itemSize: CGSize = {
        let screen = Screen(view: self.view)
        return CGSize(width: screen.width - cellMargins.width, height: screen.height - cellMargins.height)
    }()

    required init?(coder aDecoder: NSCoder) {
        let controller = CitiesController()
        self.cities = controller.cities
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = .vertical
        if #available(iOS 11.0, *) {
            flowLayout.headerReferenceSize = CGSize(width: 0, height: UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? UIApplication.shared.statusBarFrame.size.height)
        } else {
            flowLayout.headerReferenceSize = CGSize(width: 0, height: UIApplication.shared.statusBarFrame.size.height)
        }
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.itemSize = itemSize

        collectionView.isPagingEnabled = true
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: -flowLayout.headerReferenceSize.height, left: 0, bottom: 0, right: 0)

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Fetch data for all cities
        let serialQueue = DispatchQueue(label: "SerialQueue")
        for index in 0..<cities.count {
            let city = self.cities[index].name
            let country = self.cities[index].country
            weatherController.fetchForecast(city: city, country: country) { (forecasts) in
                serialQueue.sync {
                    self.cities[index].forecasts = forecasts
                }
                DispatchQueue.main.sync {
                    self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                }
            }
        }
    }
}

// MARK: UICollectionViewDataSource

extension MainViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cities.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityOverviewCell", for: indexPath) as! CityOverviewCell

        cell.cityName = self.cities[indexPath.row].name

        guard let forecasts = self.cities[indexPath.row].forecasts else { return cell }
        guard let todayForecast = forecasts.first else { return cell }

        let todayForecastDecorator = ForecastDecorator(forecast: todayForecast)
        cell.timezone = todayForecastDecorator.timezone()
        cell.temperatureLabel?.text = todayForecastDecorator.temperature(unit: .metric)
        cell.weatherLabel.text = todayForecastDecorator.weather()
        cell.weatherIcon.image = todayForecastDecorator.weatherIcon()
        cell.minTemperatureIcon.image = todayForecastDecorator.minTemperatureIcon()
        cell.minTemperatureLabel?.text = todayForecastDecorator.minTemperature(unit: .metric)
        cell.maxTemperatureIcon.image = todayForecastDecorator.maxTemperatureIcon()
        cell.maxTemperatureLabel?.text = todayForecastDecorator.maxTemperature(unit: .metric)

        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
}
