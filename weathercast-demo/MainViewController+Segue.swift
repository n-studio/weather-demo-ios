//
//  MainViewController+Segue.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: Segues

extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cityDetailViewSegue = segue as? CityDetailViewSegue, cityDetailViewSegue.identifier == "CityDetailViewSegue" {
            cityDetailViewSegue.transition = CellTransition()

            guard let vc = cityDetailViewSegue.destination as? CityDetailViewController else { return }
            vc.databaseController = databaseController
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
