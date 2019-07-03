//
//  HourlyWeatherCell.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/01.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class HourlyWeatherCell: UITableViewCell {
    @IBOutlet var hourLabel: UILabel?
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet var tempMaxLabel: UILabel?
    @IBOutlet var tempMinLabel: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        self.backgroundColor = .white
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.hourLabel?.text = nil
        self.weatherIcon?.image = nil
        self.tempMaxLabel?.text = nil
        self.tempMinLabel?.text = nil
    }
}
