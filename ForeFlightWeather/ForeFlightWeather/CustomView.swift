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
    @State var weatherContainers: [WeatherContainer]
    @FocusState var filterList: Bool
    private let jsonFetcher: JSONFetcher
    @State private var showAlert = false
    @State var weatherViews: [WeatherView] = []
    @Environment(\.modelContext) private var context
    
    init(inputText: Binding<String>, weatherContainers: [WeatherContainer], jsonFetcher: JSONFetcher) {
        self._inputText = inputText
        self.jsonFetcher = jsonFetcher
        self._weatherContainers = State(initialValue: weatherContainers)
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
                            if weatherContainers.isEmpty {
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
                } .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.5)
                )
            }
            List {
                ForEach(weatherContainers, id: \.self) { weatherContainer in
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
            if !weatherViews.isEmpty {
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
    }
    
    func onJSONSuccess(_ newWeatherContainer: WeatherContainer) {
        if !weatherContainers.contains(newWeatherContainer) {
            weatherContainers.insert(newWeatherContainer, at: 0)
            context.insert(newWeatherContainer)
        }
        updateWeatherViewsWith(newWeatherContainer.weather!)
    }
}
