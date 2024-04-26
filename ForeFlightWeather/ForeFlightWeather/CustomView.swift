//
//  CustomView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

struct WeatherView {
    @State var text: String
    @State var dateIssued: String
    @State var lat: Double
    @State var lon: Double
    @State var elevationFt: Int
}

public struct CustomView: View {
    @Binding var inputText: String
    @FocusState var filterList: Bool
    private var jsonFetcher: JSONFetcher
    @State private var showAlert = false
    @State var weatherViews: [WeatherView] = []
    @State private var fetchAutomatically = false
    @State private var weatherViewsLastUpdatedTime: String = ""
    
    init(inputText: Binding<String>, weatherContainers: [WeatherContainer], jsonFetcher: JSONFetcher) {
        self._inputText = inputText
        self.jsonFetcher = jsonFetcher
    }
    
    public var body: some View {
        VStack {
            Group{
                HStack {
                    TextField("Search for an airport", text: $inputText)
                        .padding([.horizontal, .vertical], 15)
                        .autocorrectionDisabled()
#if os(iOS)
                        .textInputAutocapitalization(.characters)
#endif
                        .focused($filterList)
                        .onAppear {
                            if jsonFetcher.weatherContainers.isEmpty {
                                jsonFetcher.fetchWeatherFor("KPWM", onSuccess: onJSONSuccess, onFailure: {_ in })
                                jsonFetcher.fetchWeatherFor("KAUS", onSuccess: onJSONSuccess, onFailure: {_ in })
                            }
                        }
                        .onSubmit {
                            if inputText.isEmpty { return }
                            jsonFetcher.fetchWeatherFor(inputText.uppercased(), onSuccess: onJSONSuccess, onFailure: {_ in
                                showAlert = true
                            })
                        }
                        .onChange(of: inputText) {
                            checkInputTextValidAirport()
                        }
                } .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.5)
                )
            }
            List {
                ForEach(jsonFetcher.weatherContainers, id: \.self) { weatherContainer in
                    if !filterList || inputText.isEmpty || weatherContainer.airport.contains(inputText.uppercased()) {
                        Text("\(weatherContainer.airport)")
                            .onTapGesture {
                                inputText = "\(weatherContainer.airport)"
                                jsonFetcher.fetchWeatherFor(inputText.uppercased(), onSuccess: onJSONSuccess, onFailure: {_ in
                                    showAlert = true
                                })
                            }
                    }
                }
            }
            Toggle("Automatically fetch every \(jsonFetcher.autoFetchSeconds) seconds.", isOn: $fetchAutomatically)
                .onChange(of: fetchAutomatically) {
                    jsonFetcher.fetchAutomatically(fetchAutomatically, onSuccess: onJSONSuccess)
                }
            if !weatherViews.isEmpty {
                Text("Last Updated: \(weatherViewsLastUpdatedTime)").multilineTextAlignment(.center)
                TabView {
                    ForEach(0..<weatherViews.count, id: \.self) { index in
                        List {
                            Text(weatherViews[index].text).multilineTextAlignment(.center)
                            Text("Date Issued: \(weatherViews[index].dateIssued)").multilineTextAlignment(.center)
                            Text("Latitude: \(weatherViews[index].lat)")
                            Text("Longitude: \(weatherViews[index].lon)")
                            Text("Elevation Feet: \(weatherViews[index].elevationFt)")
                        }
                        .tabItem {
                            if index > 1 {
                                Text("Today + \(index)")
                            } else if index == 1 {
                                Text("Tomorrow")
                            } else {
                                Text("Today")
                            }
                        }
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Airport Not Found"),
                message: Text("The airport \"\(inputText)\" could not be found.") // TODO `inputText` can be out of alignment here.
            )
        }
    }
    
    func updateWeatherViewsWith(_ weather: Weather) {
        weatherViews = [WeatherView(text: weather.report.conditions.text,
                                    dateIssued: weather.report.conditions.dateIssued,
                                    lat: weather.report.conditions.lat,
                                    lon: weather.report.conditions.lon,
                                    elevationFt: weather.report.conditions.elevationFt)]
        for forecast in weather.report.forecast.conditions {
            weatherViews.append(WeatherView(text: forecast.text,
                                            dateIssued: forecast.dateIssued,
                                            lat: forecast.lat,
                                            lon: forecast.lon,
                                            elevationFt: forecast.elevationFt))
        }
        weatherViewsLastUpdatedTime = getCurrentDisplayTime()
    }
    
    func onJSONSuccess(_ newWeatherContainer: WeatherContainer) {
        if newWeatherContainer.airport == inputText.uppercased() {
            updateWeatherViewsWith(newWeatherContainer.weather)
        }
    }
    
    func getCurrentDisplayTime() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss a"
        let result = formatter.string(from: date)
        return result
    }
    
    func checkInputTextValidAirport() {
        for weatherContainer in jsonFetcher.weatherContainers {
            if inputText.uppercased() == weatherContainer.airport {
                return
            }
        }
        weatherViews = []
    }
}
