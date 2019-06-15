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

class weathercast_demoTests: XCTestCase {

    override func setUp() {
        let forecastStub = stubForecast()
        
        Hippolyte.shared.add(stubbedRequest: forecastStub)
        Hippolyte.shared.start()
    }

    override func tearDown() {
        Hippolyte.shared.stop()
    }

    func testForecastRecord() {
        let expectation = XCTestExpectation(description: "Get HTTP response")

        let apiController = OpenAPIController()
        apiController.requestForecast(zipcode: "75000", country: "fr", completion: { jsonString in
            assert(jsonString == self.forecastBody)
            expectation.fulfill()
        })

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

    lazy var forecastBody: String = {
        if let path = Bundle.main.path(forResource: "forecast_data", ofType: "json") {
            if let json = try? String(contentsOfFile: path) {
                return json
            }
        }
        return "{}"
    }()
}
