//
//  weathercast_demoTests.swift
//  weathercast-demoTests
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import XCTest
import Hippolyte
@testable import weathercast_demo

class WeathercastDemoTests: XCTestCase {

    override func setUp() {
        let forecastStub = stubForecast()
        
        Hippolyte.shared.add(stubbedRequest: forecastStub)
        Hippolyte.shared.start()
    }

    override func tearDown() {
        Hippolyte.shared.stop()
    }

    func testTemperatureDecorator() {
        assert(TemperatureDecorator.convert(293.15, unit: .metric) == "20℃", TemperatureDecorator.convert(293.15, unit: .metric))
        assert(TemperatureDecorator.convert(293.15, unit: .imperial) == "68℉", TemperatureDecorator.convert(293.15, unit: .imperial))
    }

    func testForecastRecord() {
        let expectation = XCTestExpectation(description: "Get HTTP response")

        let controller = WeatherController()

        controller.fetchForecast(zipcode: "75000") { forecasts in
            guard let forecast = forecasts.first else {
                assert(false)
                return
            }

            assert(forecast.city_name == "Paris", "Wrong city_name: \(String(describing: forecast.city_name))")
            assert(forecast.clouds_all == 23, "Wrong clouds_all: \(forecast.clouds_all)")
            assert(forecast.date!.timeIntervalSince1970 == 1560589200, "Wrong date: \(forecast.date!.timeIntervalSince1970)")
            assert(forecast.grnd_level == 1005.15, "Wrong grnd_level: \(forecast.grnd_level)")
            assert(forecast.humidity == 51, "Wrong humidity: \(forecast.humidity)")
            assert(forecast.pressure == 1016.18, "Wrong pressure: \(forecast.pressure)")
            assert(forecast.rain_3h == 0.188, "Wrong rain_3h: \(forecast.rain_3h)")
            assert(forecast.sea_level == 1016.18, "Wrong sea_level: \(forecast.sea_level)")
            assert(forecast.snow_3h == 0, "Wrong snow_3h: \(forecast.snow_3h)")
            assert(forecast.temp == 294.06, "Wrong temp: \(forecast.temp)")
            assert(forecast.temp_max == 294.06, "Wrong temp_max: \(forecast.temp_max)")
            assert(forecast.temp_min == 290.6, "Wrong temp_min: \(forecast.temp_min)")
            assert(forecast.weather_description == "few clouds", "Wrong weather_description: \(String(describing: forecast.weather_description))")
            assert(forecast.weather_icon == "02d", "Wrong weather_icon: \(String(describing: forecast.weather_icon))")
            assert(forecast.weather_main == "Clouds", "Wrong weather_main: \(String(describing: forecast.weather_main))")
            assert(forecast.wind_deg == 249.34, "Wrong wind_deg: \(forecast.wind_deg)")
            assert(forecast.wind_speed == 4.63, "Wrong wind_speed: \(forecast.wind_speed)")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    private func stubForecast() -> StubRequest {
        let regex = try! NSRegularExpression(pattern: #"api\.openweathermap\.org\/data\/2\.5\/forecast"#)
        var stub = StubRequest(method: .GET, urlMatcher: RegexMatcher(regex: regex))
        var response = StubResponse()
        let body = forecastBody.data(using: .utf8)!
        response.body = body
        stub.response = response
        return stub
    }

    lazy private var forecastBody: String = {
        let bundle = Bundle(for: WeathercastDemoTests.self)
        guard let path = bundle.path(forResource: "forecast_data", ofType: "json"), let json = try? String(contentsOfFile: path) else { return "{}" }
        return json
    }()
}
