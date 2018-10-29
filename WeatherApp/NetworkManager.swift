//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Lalit Kumar on 29/10/18.
//  Copyright © 2018 Lalit Kumar. All rights reserved.
//

import UIKit

let OPEN_WEATHER_API_KEY = "03196249b236c1cfaffe92f7cfa4a592"

class NetworkManager: NSObject {
    class func getWeatherData(lat: Double, lon: Double, completion: @escaping ((WeatherData) -> Void)) {
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(OPEN_WEATHER_API_KEY)&units=metric"
        if let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    completion(weatherData)
                }
                catch let err {
                    print("Error:", err)
                }
            }
            task.resume()
        }
    }
}
