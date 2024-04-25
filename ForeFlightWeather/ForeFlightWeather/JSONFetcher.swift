//
//  JSONFetcher.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import Foundation

public struct JSONFetcher {
    public func fetchWeatherFor(_ airport: String, onSuccess: @escaping (_ airport: String, _ weather: Weather) -> (), onFailure: @escaping (_ airport: String) -> ()) {
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(airport)") else { return }
        var request = URLRequest(url: url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let weather = try JSONDecoder().decode(Weather.self, from: data)
                onSuccess(airport, weather)
            } catch let err {
                print("Unable to decode JSON", err)
                onFailure(airport)
            }
        }.resume()
    }
}
