//
//  ContentView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var airport = ""
    private var airports = ["KPWM", "KAUS"]
    private let jsonFetcher: JSONFetcher = JSONFetcher()

    var body: some View {
        VStack(alignment: .leading) {
            CustomView(inputText: $airport, dropDownList: airports, jsonFetcher: jsonFetcher)
        }
        .padding()
    }
}
