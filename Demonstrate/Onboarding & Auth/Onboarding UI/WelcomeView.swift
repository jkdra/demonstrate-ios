//
//  WelcomeView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("You're all set!")
                .largeTitle()
            
            Text("Welcome to Demonstrate.\nIt's a revolution.")
                .subtitle()
            Spacer()
            Button("Close") {
                
            }
            .primaryButton()
        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
