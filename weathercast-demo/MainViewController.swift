//
//  ViewController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class MainViewController: UICollectionViewController, UIViewControllerTransitioningDelegate {
    static let cellMargins = CGSize(width: 20.0, height: 88.0)
    let minimumLineSpacing: CGFloat = 88.0

    let weatherController = WeatherController()
    var cities: [City]
    var cityImages: [UIImage?]
    var selectedCellImage: UIImage?
    var selectedCellSnapshot: UIView?
    var flowLayout: UICollectionViewFlowLayout?

    let openPhotosApiController = OpenPhotosAPIController()

    lazy var itemSize: CGSize = {
        let screen = Screen(view: self.view)
        return CGSize(width: screen.width - MainViewController.cellMargins.width,
                      height: screen.height - MainViewController.cellMargins.height)
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

        setCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        fetchData()
    }
}

// MARK: UICollectionView

extension MainViewController {
    private func setCollectionView() {
        // Set UICollectionView
        flowLayout = UICollectionViewFlowLayout()
        if let flowLayout = flowLayout {
            flowLayout.scrollDirection = .vertical
            flowLayout.headerReferenceSize = CGSize(width: 0, height: MainViewController.statusBarHeight())
            flowLayout.minimumLineSpacing = minimumLineSpacing
            flowLayout.footerReferenceSize = CGSize(width: 0, height: minimumLineSpacing - flowLayout.headerReferenceSize.height)
            flowLayout.itemSize = itemSize

            collectionView.isPagingEnabled = true
            collectionView.setCollectionViewLayout(flowLayout, animated: false)
            if #available(iOS 11.0, *) {
                collectionView.contentInset = UIEdgeInsets(top: -flowLayout.headerReferenceSize.height,
                                                           left: 0,
                                                           bottom: 0,
                                                           right: 0)
            }
            else {
                collectionView.contentInset = UIEdgeInsets.zero
            }

        }

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
    }
}

// MARK: UI Helper

extension MainViewController {
    static func statusBarHeight() -> CGFloat {
        if #available(iOS 11.0, *) {
            let height = UIApplication.shared.delegate?.window??.safeAreaInsets.top
            return height ?? UIApplication.shared.statusBarFrame.size.height
        }
        else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
}
