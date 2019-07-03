//
//  CityDetailViewController+Clock.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: Clock

extension CityDetailViewController: ClockDelegate {
    func resetClock() {
        clock?.stopClock()
        clock = Clock()
        clock?.timezone = timezone
        clock?.delegate = self
        clock?.startClock()
    }

    func clockDidTick(dateString: String, timeString: String) {
        DispatchQueue.main.async {
            self.dateLabel?.text = dateString
            self.timeLabel?.text = timeString
        }
    }
}
