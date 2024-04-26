//
//  JSONFetcher.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import Foundation

public struct JSONFetcher {
    func fetchWeatherFor(_ airport: String, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> (), onFailure: @escaping (_ airport: String) -> ()) {
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(airport)") else { return }
        var request = URLRequest(url: url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                onSuccess(WeatherContainer(airport: airport, weather: weather))
            } catch let err {
                print("Unable to decode JSON", err)
                onFailure(airport)
            }
        }.resume()
    }
}
