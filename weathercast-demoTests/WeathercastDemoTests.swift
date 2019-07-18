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
        let expectation0 = XCTestExpectation(description: "Get HTTP response")

        let controller = WeatherController(weatherAPIController: OpenWeatherAPIController(),
                                           databaseController: CoreDataController.shared,
                                           weatherDataFactory: WeatherCoreDataFactory())
        let now = Date(timeIntervalSince1970: TimeInterval(1560589200))
        controller.fetchForecast(city: "Paris", country: "fr", from: now, type: "daily") { forecasts, error in
            assert(forecasts.count == 6, "Wrong count of forecasts \(forecasts.count)")
            guard let forecast = forecasts.first else {
                assert(false)
                return
            }

            assert(forecast.cityName == "Paris", "Wrong city_name: \(String(describing: forecast.cityName))")
            assert(forecast.cloudsAll == 11.0, "Wrong clouds_all: \(forecast.cloudsAll)")
            assert(forecast.date!.timeIntervalSince1970 == 1560589200, "Wrong date: \(forecast.date!.timeIntervalSince1970)")
            assert(forecast.grndLevel.rounded(precision: 3) == 1005.878, "Wrong grnd_level: \(forecast.grndLevel)")
            assert(forecast.humidity.rounded(precision: 3) == 56.2, "Wrong humidity: \(forecast.humidity)")
            assert(forecast.pressure.rounded(precision: 3) == 1016.872, "Wrong pressure: \(forecast.pressure)")
            assert(forecast.rain3h.rounded(precision: 3) == 0.15, "Wrong rain_3h: \(forecast.rain3h)")
            assert(forecast.seaLevel.rounded(precision: 3) == 1016.872, "Wrong sea_level: \(forecast.seaLevel)")
            assert(forecast.snow3h.rounded(precision: 3) == 0, "Wrong snow_3h: \(forecast.snow3h)")
            assert(forecast.temp.rounded(precision: 3) == 294.06, "Wrong temp: \(forecast.temp)")
            assert(forecast.tempMax.rounded(precision: 3) == 296.11, "Wrong temp_max: \(forecast.tempMax)")
            assert(forecast.tempMin.rounded(precision: 3) == 289.083, "Wrong temp_min: \(forecast.tempMin)")
            assert(forecast.weatherId == 500, "Wrong weather_description: \(String(describing: forecast.weatherId))")
            assert(forecast.weatherDescription == "light rain", "Wrong weather_description: \(String(describing: forecast.weatherDescription))")
            assert(forecast.weatherIcon == "10d", "Wrong weather_icon: \(String(describing: forecast.weatherIcon))")
            assert(forecast.weatherMain == "Rain", "Wrong weather_main: \(String(describing: forecast.weatherMain))")
            assert(forecast.windDeg.rounded(precision: 3) == 237.109, "Wrong wind_deg: \(forecast.windDeg)")
            assert(forecast.windSpeed.rounded(precision: 3) == 4.904, "Wrong wind_speed: \(forecast.windSpeed)")
            expectation0.fulfill()
        }

        wait(for: [expectation0], timeout: 5.0)

        let expectation1 = XCTestExpectation(description: "Get CoreData response")

        let coredata = CoreDataController()
        coredata.fetchIncomingForecasts(city: "Paris", from: now, type: "3hourly") { (forecasts, _error) in
            guard let forecast = forecasts.first else {
                assert(false)
                return
            }
            assert(forecast.cityName == "Paris", "Wrong city_name: \(String(describing: forecast.cityName))")
            assert(forecast.cloudsAll == 23.0, "Wrong clouds_all: \(forecast.cloudsAll)")
            assert(forecast.date!.timeIntervalSince1970 == 1560589200, "Wrong date: \(forecast.date!.timeIntervalSince1970)")
            assert(forecast.grndLevel.rounded(precision: 3) == 1005.15, "Wrong grnd_level: \(forecast.grndLevel)")
            assert(forecast.humidity.rounded(precision: 3) == 51.0, "Wrong humidity: \(forecast.humidity)")
            assert(forecast.pressure.rounded(precision: 3) == 1016.18, "Wrong pressure: \(forecast.pressure)")
            assert(forecast.rain3h.rounded(precision: 3) == 0.188, "Wrong rain_3h: \(forecast.rain3h)")
            assert(forecast.seaLevel.rounded(precision: 3) == 1016.18, "Wrong sea_level: \(forecast.seaLevel)")
            assert(forecast.snow3h.rounded(precision: 3) == 0, "Wrong snow_3h: \(forecast.snow3h)")
            assert(forecast.temp.rounded(precision: 3) == 294.06, "Wrong temp: \(forecast.temp)")
            assert(forecast.tempMax.rounded(precision: 3) == 294.06, "Wrong temp_max: \(forecast.tempMax)")
            assert(forecast.tempMin.rounded(precision: 3) == 290.6, "Wrong temp_min: \(forecast.tempMin)")
            assert(forecast.weatherId == 801, "Wrong weather_description: \(String(describing: forecast.weatherId))")
            assert(forecast.weatherDescription == "few clouds", "Wrong weather_description: \(String(describing: forecast.weatherDescription))")
            assert(forecast.weatherIcon == "02d", "Wrong weather_icon: \(String(describing: forecast.weatherIcon))")
            assert(forecast.weatherMain == "Clouds", "Wrong weather_main: \(String(describing: forecast.weatherMain))")
            assert(forecast.windDeg.rounded(precision: 3) == 249.34, "Wrong wind_deg: \(forecast.windDeg)")
            assert(forecast.windSpeed.rounded(precision: 3) == 4.63, "Wrong wind_speed: \(forecast.windSpeed)")
            expectation1.fulfill()
        }
        wait(for: [expectation1], timeout: 5.0)
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
