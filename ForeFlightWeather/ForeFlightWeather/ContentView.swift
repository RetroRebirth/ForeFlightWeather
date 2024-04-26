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
    @Environment(\.modelContext) private var context

    var body: some View {
        VStack(alignment: .leading) {
            let jsonFetcher: JSONFetcher = JSONFetcher(weatherContainers: weatherContainers, context: context)
            CustomView(inputText: $airport, weatherContainers: weatherContainers, jsonFetcher: jsonFetcher)
        }
        .padding()
    }
}
