//
//  OpenPhotosAPIController.swift
//  weathercast-demo
//
//  Created by Matthew Nguyen on 2019/06/15.
//  Copyright © 2019 Solfanto, Inc. All rights reserved.
//

import UIKit

class OpenPhotosAPIController {
    private lazy var cachedSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        config.urlCache = nil
        return URLSession(configuration: config)
    }()
    private var dataTask: URLSessionDataTask?
    typealias StringResult = (String) -> ()
    typealias ImageResult = (UIImage) -> ()

    lazy var openPhotosApiKey: String = {
        guard let path = Bundle.main.path(forResource: "Env", ofType: "plist") else { return "" }
        guard let keys = NSDictionary(contentsOfFile: path) else { return "" }

        return keys.value(forKey: "unsplashAccessKey") as! String
    }()

    func searchPhoto(query: String, completion: @escaping StringResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: "https://api.unsplash.com/search/photos") {
            urlComponents.query = "query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)&page=1&per_page=1&client_id=\(openPhotosApiKey)"
            guard let url = urlComponents.url else { return }
            dataTask = cachedSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
                guard let results = json["results"] as? [[String: Any]], let result = results.first else { return }
                guard let urls = result["urls"] as? [String: Any], let url = urls["regular"] as? String else { return }
                completion(url)
            }
        }
        dataTask?.resume()
    }

    func getPhoto(urlString: String, completion: @escaping ImageResult) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: urlString) {
            guard let url = urlComponents.url else { return }
            dataTask = cachedSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }

                guard let data = data else { return }
                guard let image = UIImage(data: data) else { return }
                completion(image)
            }
        }
        dataTask?.resume()
    }
}
