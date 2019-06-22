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

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    weak var forecast: Forecast? {
        didSet {
            guard let forecast = self.forecast, let date = forecast.date else { return }
            self.dayLabel?.text = dateFormatter.string(from: date)
        }
    }
}
