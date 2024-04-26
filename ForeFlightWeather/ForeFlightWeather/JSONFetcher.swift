//
//  JSONFetcher.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import Foundation
import SwiftData
import SwiftUI

public class JSONFetcher {
    private(set) var weatherContainers: [WeatherContainer]
    private var context: ModelContext
    
    init(weatherContainers: [WeatherContainer], context: ModelContext) {
        self.weatherContainers = weatherContainers
        self.context = context
    }
    
    func fetchWeatherFor(_ airport: String, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> (), onFailure: @escaping (_ airport: String) -> ()) {
        
        checkCacheFor(airport, onSuccess: onSuccess)
        
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(airport)") else { return }
        var request = URLRequest(url: url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            do {
                let newWeather = try JSONDecoder().decode(Weather.self, from: data)
                let newWeatherContainer: WeatherContainer = WeatherContainer(airport: airport, weather: newWeather)
                if !self.weatherContainers.contains(newWeatherContainer) {
                    self.saveData(newWeatherContainer: newWeatherContainer)
                }
                onSuccess(newWeatherContainer)
            } catch let err {
                print("Unable to decode JSON", err)
                onFailure(airport)
            }
        }.resume()
    }
    
    func saveData(newWeatherContainer: WeatherContainer) {
        self.weatherContainers.insert(newWeatherContainer, at: 0)
        self.context.insert(newWeatherContainer)
    }
    
    func checkCacheFor(_ airport: String, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> ()) {
        for weatherContainer in weatherContainers {
            if weatherContainer.airport == airport {
                onSuccess(weatherContainer)
                return
            }
        }
    }
}
