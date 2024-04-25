//
//  CustomView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

public struct CustomView: View {
    @Binding var inputText: String
    @State var dropDownList = [String]()
    @FocusState var filterList: Bool
    private let jsonFetcher: JSONFetcher
    @State private var showAlert = false
    @State var dateIssued: String = ""
    @State var lat: Double = 0.0
    @State var lon: Double = 0.0
    @State var elevationFt: Int = 0
    @State var tempC: Int = 0
    
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
                        .autocapitalization(.allCharacters)
                        .focused($filterList)
                        .onSubmit {
                            // TODO check if cached before fetching.
                            jsonFetcher.fetchWeatherFor(inputText.uppercased(), onSuccess: {airport, weather in
                                if !airport.isEmpty && !dropDownList.contains(airport) {
                                    dropDownList.insert(airport, at: 0)
                                }
                                updateWeatherViewWith(weather)
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
                                    updateWeatherViewWith(weather)
                                }, onFailure: {airport in
                                    showAlert = true
                                })
                            }
                    }
                }
            }
            Text("Date Issued: \(dateIssued)")
            Text("Latitude: \(lat)")
            Text("Longitude: \(lon)")
            Text("Elevation Feet: \(elevationFt)")
            Text("Temperature (C): \(tempC)")
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Airport Not Found"),
                message: Text("The airport \"\(inputText)\" could not be found.") // TODO `inputText` can be out of alignment here.
            )
        }
    }
    
    func updateWeatherViewWith(_ weather: Weather) {
        self.dateIssued = weather.report.conditions.dateIssued
        self.lat = weather.report.conditions.lat
        self.lon = weather.report.conditions.lon
        self.elevationFt = weather.report.conditions.elevationFt
        self.tempC = weather.report.conditions.tempC
    }
}
