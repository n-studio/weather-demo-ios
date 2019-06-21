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
    var cities: [City]

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
        flowLayout.minimumInteritemSpacing = 44
        flowLayout.minimumLineSpacing = 44

        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = flowLayout

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Fetch data for all cities
        let serialQueue = DispatchQueue(label: "SerialQueue")
        for index in 0..<cities.count {
            let zipcode = self.cities[index].zipcode
            weatherController.fetchForecast(zipcode: zipcode) { (forecasts) in
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
        cell.temperatureLabel?.text = todayForecastDecorator.temperature(unit: .metric)

        return cell
    }
}

// MARK:

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = Screen(view: self.view)
        let margin: CGFloat = 20
        return CGSize(width: screen.width - margin, height: (screen.width - margin) / screen.aspectRatio)
    }
}
