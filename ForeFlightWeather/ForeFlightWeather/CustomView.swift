//
//  CustomView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

struct WeatherView {
    @State var text: String = ""
    @State var dateIssued: String = ""
    @State var lat: Double = 0.0
    @State var lon: Double = 0.0
    @State var elevationFt: Int = 0
}

public struct CustomView: View {
    @Binding var inputText: String
    @State var dropDownList = [String]()
    @FocusState var filterList: Bool
    private let jsonFetcher: JSONFetcher
    @State private var showAlert = false
    @State private var showForecast = false
    @State var weatherViews: [WeatherView] = []
    
    public init(inputText: Binding<String>, dropDownList: [String], jsonFetcher: JSONFetcher) {
        self._inputText = inputText
        self._dropDownList = State(initialValue: dropDownList)
        self.jsonFetcher = jsonFetcher
    }
    
    public var body: some View {
        VStack {
            Group{
                HStack {
                    TextField("Select an airport", text: $inputText)
                        .padding([.horizontal, .vertical], 15)
                        .autocorrectionDisabled()
                    #if os(iOS)
                        .textInputAutocapitalization(.characters)
                    #endif
                        .focused($filterList)
                        .onSubmit {
                            // TODO check if cached before fetching.
                            jsonFetcher.fetchWeatherFor(inputText.uppercased(), onSuccess: {airport, weather in
                                if !airport.isEmpty && !dropDownList.contains(airport) {
                                    dropDownList.insert(airport, at: 0)
                                }
                                updateWeatherViewsWith(weather)
                            }, onFailure: {_ in
                                showAlert = true
                            })
                        }
                    Image(systemName: "chevron.down")
                        .padding()
                } .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.5)
                )
            }
            List(){
                ForEach(dropDownList, id: \.self) { airport in
                    if !filterList || inputText.isEmpty || airport.contains(inputText.uppercased()) {
                        Text("\(airport)")
                            .onTapGesture {
                                inputText = "\(airport)"
                                jsonFetcher.fetchWeatherFor(inputText.uppercased(), onSuccess: {airport, weather in
                                    updateWeatherViewsWith(weather)
                                }, onFailure: {airport in
                                    showAlert = true
                                })
                            }
                    }
                }
            }
            if !weatherViews.isEmpty {
                Toggle(isOn: $showForecast) {
                    Text("Show Forecast")
                }
                if showForecast {
                    TabView {
                        ForEach(1..<weatherViews.count, id: \.self) { index in
                            VStack {
                                Text(weatherViews[index].text).multilineTextAlignment(.center)
                                Spacer()
                                Text("Date Issued: \(weatherViews[index].dateIssued)").multilineTextAlignment(.center)
                                Text("Latitude: \(weatherViews[index].lat)")
                                Text("Longitude: \(weatherViews[index].lon)")
                                Text("Elevation Feet: \(weatherViews[index].elevationFt)")
                            }
                            .tabItem {
                                Text("Today + \(index)")
                            }
                        }
                    }
                } else {
                    TabView {
                        VStack {
                            Text(weatherViews[0].text).multilineTextAlignment(.center)
                            Spacer()
                            Text("Date Issued: \(weatherViews[0].dateIssued)").multilineTextAlignment(.center)
                            Text("Latitude: \(weatherViews[0].lat)")
                            Text("Longitude: \(weatherViews[0].lon)")
                            Text("Elevation Feet: \(weatherViews[0].elevationFt)")
                        }
                        .tabItem {
                            Text("Today")
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
}
