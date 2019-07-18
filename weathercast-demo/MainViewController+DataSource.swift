//
//  MainViewController+DataSource.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

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
        cell.openPhotosApiController = openPhotosApiController
        cell.cityName = self.cities[indexPath.row].name
        cell.backgroundImage = self.cityImages[indexPath.row]

        guard let forecastDecorators = self.cities[indexPath.row].forecastDecorators else { return cell }

        cell.forecastDecorators = []
        for forecastDecorator in forecastDecorators {
            cell.forecastDecorators.append(forecastDecorator)
        }
        cell.reload()
        return cell
    }
}

