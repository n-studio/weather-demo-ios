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
    private var dataTask: URLSessionDataTask?
    typealias JSONResult = (Data) -> ()

    lazy var openWeatherMapApiKey: String = {
        guard let path = Bundle.main.path(forResource: "Env", ofType: "plist") else { return "" }
        guard let keys = NSDictionary(contentsOfFile: path) else { return "" }

        return keys.value(forKey: "openWeatherMapApiKey") as! String
    }()

    func requestForecast(zipcode: String, country: String, completion: @escaping JSONResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "http://api.openweathermap.org/data/2.5/forecast") {
            urlComponents.query = "zip=\(zipcode),\(country)&appId=\(openWeatherMapApiKey)"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                if let error = error {
                    NSLog("Error: \(error.localizedDescription)")
                }
                else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    completion(data)
                }
            }
        }
        dataTask?.resume()
    }
}
