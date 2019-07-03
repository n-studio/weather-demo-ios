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

