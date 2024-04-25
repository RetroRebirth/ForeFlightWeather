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
    @State private var weather = "raw json here"
    
    var body: some View {
        VStack {
            AirportTextFieldListView(inputText: $airport, dropDownList: airports)
            Text(weather)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
