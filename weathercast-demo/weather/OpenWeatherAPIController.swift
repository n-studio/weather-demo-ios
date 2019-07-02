//
//  OpenWeatherAPIController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import Foundation

class OpenWeatherAPIController {
    private let defaultSession = URLSession(configuration: .default)
    private var dataTasks: [String:URLSessionDataTask] = [:]
    typealias JSONResult = (Data?, Error?) -> ()

    lazy var openWeatherMapApiKey: String = {
        guard let path = Bundle.main.path(forResource: "Env", ofType: "plist") else { return "" }
        guard let keys = NSDictionary(contentsOfFile: path) else { return "" }

        return keys.value(forKey: "openWeatherMapApiKey") as! String
    }()

    func requestForecast(city: String, country: String, completion: @escaping JSONResult) {
        dataTasks["\(city),\(country)"]?.cancel()
        if var urlComponents = URLComponents(string: "http://api.openweathermap.org/data/2.5/forecast") {
            urlComponents.query = "q=\(city),\(country)&appId=\(openWeatherMapApiKey)"
            guard let url = urlComponents.url else { return }
            dataTasks["\(city),\(country)"] = defaultSession.dataTask(with: url) { [weak self] (data, response, error) in
                defer { self?.dataTasks["\(city),\(country)"] = nil }

                if let error = error {
                    completion(nil, error)
                }
                else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(data, nil)
                }
                else {
                    completion(nil, UnknownError.withMessage(string: "[requestForecast] Unknown error"))
                }
            }
        }
        dataTasks["\(city),\(country)"]?.resume()
    }
}
