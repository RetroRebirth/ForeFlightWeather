//
//  ContentView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

struct ContentView: View {
    @State private var airport: String = "KPWM"
    @FocusState private var airportFieldIsFocused: Bool
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            TextField(
                "Airport",
                text: $airport
            )
            .focused($airportFieldIsFocused)
            .onSubmit {
//                validate(name: airport)
            }
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .border(.secondary)

            Text(airport)
                .foregroundColor(airportFieldIsFocused ? .red : .blue)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
