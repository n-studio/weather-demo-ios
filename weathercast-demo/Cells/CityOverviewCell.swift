//
//  CityOverviewCell.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class CityOverviewCell: UICollectionViewCell {
    let openPhotosApiController = OpenPhotosAPIController()
    var cityName: String? {
        didSet {
            openPhotosApiController.searchPhoto(query: "Paris") { (urlString) in
                self.openPhotosApiController.getPhoto(urlString: urlString) { (image) in
                    DispatchQueue.main.async {
                        self.backgroundView = UIImageView(image: image.alpha(0.7))
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
