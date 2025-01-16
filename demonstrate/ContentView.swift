//
//  ContentView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/13/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack (spacing: -2) {
            TextInput("Test", text: $text, location: .top)
            TextInput("Test", text: $text, location: .center)
            TextInput("Test", text: $text, location: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
