//
//  ViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CityOverviewCell.self, forCellWithReuseIdentifier: "CityOverview")
        collectionView.alwaysBounceVertical = true
    }
}

extension MainViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityOverview", for: indexPath) as! CityOverviewCell
        cell.cityName = "Paris"
        return cell
    }
}
