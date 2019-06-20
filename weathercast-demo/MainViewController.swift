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

        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 44
        flowLayout.minimumLineSpacing = 44

        collectionView.isPagingEnabled = true
        collectionView.collectionViewLayout = flowLayout

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CityOverviewCell.self, forCellWithReuseIdentifier: "CityOverview")
        collectionView.alwaysBounceVertical = true
    }
}

// MARK: UICollectionViewDataSource

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

// MARK:

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screen = Screen(view: self.view)
        let margin: CGFloat = 20
        return CGSize(width: screen.width - margin, height: (screen.width - margin) / screen.aspectRatio)
    }
}
