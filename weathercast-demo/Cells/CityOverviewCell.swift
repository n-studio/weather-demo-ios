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
                        let imageView = UIImageView(image: image.alpha(0.7))
                        imageView.contentMode = .scaleAspectFill
                        imageView.layer.cornerRadius = 10.0
                        imageView.layer.masksToBounds = true
                        self.backgroundView = imageView
                    }
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
