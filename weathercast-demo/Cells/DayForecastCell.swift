//
//  DayForecastCell.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/23.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class DayForecastCell: UICollectionViewCell {
    @IBOutlet var dayLabel: UILabel?
    @IBOutlet var weatherIcon: UIImageView?
    @IBOutlet var tempMinLabel: UILabel?
    @IBOutlet var tempMaxLabel: UILabel?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    weak var forecastDecorator: ForecastDecorator? {
        didSet {
            guard let forecastDecorator = self.forecastDecorator else { return }
            self.dayLabel?.text = forecastDecorator.weekday
            self.weatherIcon?.image = forecastDecorator.weatherIcon(forceDayTime: true)
            self.tempMinLabel?.text = forecastDecorator.temperatureMin(unit: .metric)
            self.tempMaxLabel?.text = forecastDecorator.temperatureMax(unit: .metric)
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.contentView.addShadowToSubviews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        (self.backgroundView as? UIImageView)?.image = nil
        self.dayLabel?.text = nil
        self.weatherIcon?.image = nil
        self.tempMinLabel?.text = nil
        self.tempMaxLabel?.text = nil
    }
}
