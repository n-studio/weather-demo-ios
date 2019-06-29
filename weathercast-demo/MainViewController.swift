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
        self.navigationController?.delegate = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        if #available(iOS 11.0, *) {
            let height = UIApplication.shared.delegate?.window??.safeAreaInsets.top
            flowLayout.headerReferenceSize = CGSize(width: 0,
                                                    height: height ?? UIApplication.shared.statusBarFrame.size.height)
        } else {
            flowLayout.headerReferenceSize = CGSize(width: 0,
                                                    height: UIApplication.shared.statusBarFrame.size.height)
        }
        flowLayout.minimumLineSpacing = minimumLineSpacing
        flowLayout.footerReferenceSize = CGSize(width: 0, height: minimumLineSpacing - flowLayout.headerReferenceSize.height)
        flowLayout.itemSize = itemSize

        collectionView.isPagingEnabled = true
        collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.contentInset = UIEdgeInsets(top: -flowLayout.headerReferenceSize.height,
                                                   left: 0,
                                                   bottom: 0,
                                                   right: 0)

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
                    DispatchQueue.main.sync {
                        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    }
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

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.cities.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityOverviewCell",
                                                      for: indexPath) as! CityOverviewCell

        cell.cityName = self.cities[indexPath.row].name

        guard let forecasts = self.cities[indexPath.row].forecasts else { return cell }
        
        cell.forecasts = []
        for forecast in forecasts {
            cell.forecasts.append(forecast)
        }

        return cell
    }
}

// MARK: UINavigationControllerDelegate

extension MainViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = CellTransition()
        transition.pop = toVC is MainViewController
        return transition
    }
}

// MARK: Segues

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityDetailViewSegue" {
            guard let vc = segue.destination as? CityDetailViewController else { return }
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            vc.forecasts = self.cities[indexPath.row].forecasts!
            vc.
        }
    }
}
