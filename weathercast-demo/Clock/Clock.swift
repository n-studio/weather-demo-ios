//
//  Clock.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/23.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

protocol ClockDelegate {
    func clockDidTick(dateString: String, timeString: String)
}

class Clock {
    var timer: Timer?
    var delegate: ClockDelegate?

    var timezone: TimeZone = TimeZone.current

    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = timezone
        return formatter
    }()

    lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = timezone
        return formatter
    }()
    
    func startClock() {
        stopClock()
        tickClock()
        timer = Timer.scheduledTimer(timeInterval: 10.0,
                                     target: self,
                                     selector: #selector(tickClock),
                                     userInfo: nil,
                                     repeats: true)
    }

    func stopClock() {
        timer?.invalidate()
        timer = nil
    }

    @objc func tickClock() {
        let date = Date()
        self.delegate?.clockDidTick(dateString: dateFormatter.string(from: date),
                                    timeString: timeFormatter.string(from: date))
    }
}
