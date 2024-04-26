// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weather = try? JSONDecoder().decode(Weather.self, from: jsonData)

import Foundation
import SwiftData

@Model
class WeatherContainer: Hashable {
    var airport: String
    var weather: Weather
    
    init(airport: String, weather: Weather) {
        self.airport = airport
        self.weather = weather
    }
    
    static func == (lhs: WeatherContainer, rhs: WeatherContainer) -> Bool {
        return lhs.airport == rhs.airport
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(airport)
        hasher.combine(weather)
    }
}

// MARK: - Weather
public struct Weather: Codable, Hashable {
    let report: Report
    
    public static func == (lhs: Weather, rhs: Weather) -> Bool {
        return lhs.report == rhs.report
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(report)
    }
}

// MARK: - Report
struct Report: Codable, Hashable {
    let conditions: Conditions
    let forecast: ReportForecast
    
    public static func == (lhs: Report, rhs: Report) -> Bool {
        return lhs.conditions == rhs.conditions && lhs.forecast == rhs.forecast
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(conditions)
        hasher.combine(forecast)
    }
}

// MARK: - Conditions
struct Conditions: Codable, Hashable {
    let text: String
    let dateIssued: String
    let lat, lon: Double
    let elevationFt: Int
    
    public static func == (lhs: Conditions, rhs: Conditions) -> Bool {
        return lhs.text == rhs.text && lhs.dateIssued == rhs.dateIssued && lhs.lat == rhs.lat && lhs.lon == rhs.lon && lhs.elevationFt == rhs.elevationFt
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(dateIssued)
        hasher.combine(lat)
        hasher.combine(lon)
        hasher.combine(elevationFt)
    }
}

// MARK: - ReportForecast
struct ReportForecast: Codable, Hashable {
    let conditions: [Conditions]
    
    public static func == (lhs: ReportForecast, rhs: ReportForecast) -> Bool {
        return lhs.conditions == rhs.conditions
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(conditions)
    }
}
