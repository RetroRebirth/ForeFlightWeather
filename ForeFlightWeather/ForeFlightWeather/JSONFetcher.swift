//
//  JSONFetcher.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import Foundation
import SwiftData
import SwiftUI

extension Data
{
    func printJSON()
    {
        if let JSONString = String(data: self, encoding: String.Encoding.utf8)
        {
            print(JSONString)
        }
    }
}

public class JSONFetcher {
    private(set) var weatherContainers: [WeatherContainer]
    private var context: ModelContext
    let autoFetchSeconds: Int = 5
    var timer = Timer()
    
    init(weatherContainers: [WeatherContainer], context: ModelContext) {
        self.weatherContainers = weatherContainers
        self.context = context
    }
    
    func fetchWeatherFor(_ airport: String, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> (), onFailure: @escaping (_ airport: String) -> ()) {
        
        let inCache = checkCacheFor(airport, onSuccess: onSuccess)
        
        guard let url = URL(string: "https://qa.foreflight.com/weather/report/\(airport)") else { return }
        var request = URLRequest(url: url)
        request.addValue("1", forHTTPHeaderField: "ff-coding-exercise")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if !inCache {
                    onFailure(airport)
                }
                return
            }
            do {
//                data.printJSON()
                let newWeather = try JSONDecoder().decode(Weather.self, from: data)
                let newWeatherContainer: WeatherContainer = WeatherContainer(airport: airport, weather: newWeather)
                if !self.weatherContainers.contains(newWeatherContainer) {
                    self.saveDataFor(newWeatherContainer)
                }
                onSuccess(newWeatherContainer)
            } catch {
                if !inCache {
                    onFailure(airport)
                }
            }
        }.resume()
    }
    
    func saveDataFor(_ newWeatherContainer: WeatherContainer) {
        self.weatherContainers.insert(newWeatherContainer, at: 0)
        self.context.insert(newWeatherContainer)
    }
    
    func checkCacheFor(_ airport: String, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> ()) -> Bool {
        for weatherContainer in weatherContainers {
            if weatherContainer.airport == airport {
                onSuccess(weatherContainer)
                return true
            }
        }
        return false
    }
    
    func setAutomaticFetching(_ fetchAutomatically: Bool, onSuccess: @escaping (_ weatherContainer: WeatherContainer) -> ()) {
        if fetchAutomatically {
            self.timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(autoFetchSeconds), repeats: true, block: { _ in
                for weatherContainer in self.weatherContainers {
                    self.fetchWeatherFor(weatherContainer.airport, onSuccess: onSuccess, onFailure: {_ in })
                }
            })
        } else {
            timer.invalidate()
        }
    }
}
