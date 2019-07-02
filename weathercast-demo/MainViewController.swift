//
//  ViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    let weatherController = WeatherController()
    let minimumLineSpacing: CGFloat = 88.0
    let cellMargins = CGSize(width: 20, height: 88.0)
    var cities: [City]
    var cityImages: [UIImage?]
    var selectedCellImage: UIImage?
    var selectedCellSnapshot: UIView?
    var flowLayout: UICollectionViewFlowLayout?

    let openPhotosApiController = OpenPhotosAPIController()

    lazy var itemSize: CGSize = {
        let screen = Screen(view: self.view)
        return CGSize(width: screen.width - cellMargins.width, height: screen.height - cellMargins.height)
    }()

    required init?(coder aDecoder: NSCoder) {
        let controller = CitiesController()
        self.cities = controller.cities
        self.cityImages = Array(repeating: nil, count: self.cities.count)
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Set UICollectionView
        flowLayout = UICollectionViewFlowLayout()
        if let flowLayout = flowLayout {
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
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Fetch data for all cities
        let now = Date()
        let serialQueue = DispatchQueue(label: "SerialQueue")
        for index in 0..<cities.count {
            let city = self.cities[index].name
            let country = self.cities[index].country
            weatherController.fetchForecast(city: city, country: country, from: now) { (forecasts, error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                }
                else {
                    serialQueue.sync {
                        self.cities[index].forecasts = forecasts
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                        }
                    }
                }
            }
            fetchBackgroundImage(query: city) { (image) in
                serialQueue.sync {
                    self.cityImages[index] = image.alpha(0.8)
                    DispatchQueue.main.async {
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
        cell.backgroundImage = self.cityImages[indexPath.row]

        guard let forecasts = self.cities[indexPath.row].forecasts else { return cell }
        
        cell.forecasts = []
        for forecast in forecasts {
            cell.forecasts.append(forecast)
        }
        return cell
    }
}

// MARK: UICollectionViewDelegate

extension MainViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCellImage = self.cityImages[indexPath.row]

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }

        selectedCellSnapshot = UIImageView(image: UIImage(view: cell.contentView))
    }
}

// MARK: Segues

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CityDetailViewSegue" {
            guard let vc = segue.destination as? CityDetailViewController else { return }
            vc.transitioningDelegate = self
            vc.modalPresentationStyle = .custom
            guard let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            guard let cell = sender as? CityOverviewCell else { return }
            vc.cityName = self.cities[indexPath.row].name
            if let image = (cell.backgroundView as? UIImageView)?.image {
                let backgroundView = UIImageView(image: image)
                backgroundView.contentMode = .scaleAspectFill
                vc.tableView.backgroundView = backgroundView
            }
        }
    }
}

// MARK: BackgroundImage

extension MainViewController {
    typealias ImageResult = (UIImage) -> ()

    private func fetchBackgroundImage(query: String, completion: @escaping ImageResult) {
        if let photoFromCache = openPhotosApiController.photosCache.object(forKey: query) as? UIImage {
            completion(photoFromCache)
            return
        }
        openPhotosApiController.searchPhoto(query: query) { (urlString) in
            self.openPhotosApiController.getPhoto(query: query, urlString: urlString) { (image) in
                completion(image)
            }
        }
    }
}
