//
//  AirportTextFieldListView.swift
//  ForeFlightWeather
//
//  Created by Christopher Williams on 4/25/24.
//

import SwiftUI

public struct AirportTextFieldListView: View {
    @Binding var inputText: String
    @State var dropDownList = [String]()
    @State var filterList = false
    
    public init(inputText: Binding<String>, dropDownList: [String]) {
        self._inputText = inputText
        self._dropDownList = State(initialValue: dropDownList)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group{
                HStack {
                    TextField("Select an airport", text: $inputText)
                        .padding([.horizontal, .vertical], 15)
                        .autocorrectionDisabled()
                        .autocapitalization(.allCharacters)
                        .onTapGesture {
                            filterList = true
                        }
                        .onSubmit {
                            filterList = false
                            // TODO validate before adding to list
                            if !dropDownList.contains(inputText.uppercased()) {
                                dropDownList.insert(inputText.uppercased(), at: 0)
                            }
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
                                filterList = false
                            }
                    }
                }
            }
        }
    }
}
