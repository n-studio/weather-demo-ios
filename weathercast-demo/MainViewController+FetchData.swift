//
//  MainViewController+FetchData.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/07/03.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

// MARK: Fetch data

extension MainViewController {
    typealias ImageResult = (UIImage) -> ()

    // Fetch data for all cities
    func fetchData() {
        let now = Date()
        let serialQueue = DispatchQueue(label: "com.solfanto.weather.SerialQueue", qos: .userInitiated)
        for index in 0..<cities.count {
            let city = self.cities[index].name
            let country = self.cities[index].country

            // Fetch weather data
            weatherController?.fetchForecast(city: city, country: country, from: now, type: "daily") { (forecasts, error) in
                if let error = error {
                    NSLog(error.localizedDescription)
                }
                else {
                    serialQueue.sync {
                        self.cities[index].forecastDecorators = ForecastDecorator.collection(forecasts)
                        DispatchQueue.main.async {
                            self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                        }
                    }
                }
            }

            // Fetch background images
            fetchBackgroundImage(query: city) { (image) in
                serialQueue.sync {
                    self.cityImages[index] = image.alpha(0.8)
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [IndexPath(row: index, section: 0)])
                    }
                }
            }
        }
    }

    private func fetchBackgroundImage(query: String, completion: @escaping ImageResult) {
        if let photoFromCache = openPhotosApiController?.photosCache.object(forKey: query) as? UIImage {
            completion(photoFromCache)
            return
        }
        openPhotosApiController?.searchPhoto(query: query) { (urlString) in
            self.openPhotosApiController?.getPhoto(query: query, urlString: urlString) { (image) in
                completion(image)
            }
        }
    }
}
