//
//  ContentView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var airport: String = ""
    @Query var weatherContainers: [WeatherContainer]
    private let jsonFetcher: JSONFetcher = JSONFetcher()

    var body: some View {
        VStack(alignment: .leading) {
            CustomView(inputText: $airport, weatherContainers: weatherContainers, jsonFetcher: jsonFetcher)
        }
        .padding()
    }
}
