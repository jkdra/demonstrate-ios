//
//  WelcomeView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct WelcomeView: View {
    
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("You're all set!")
                .largeTitle()
            
            Text("Welcome to Demonstrate.\nIt's a revolution.")
                .headline()
            
            Spacer()
            Button("Close") { isPresented = false }
                .primaryButton()
        }
        .navigationBarBackButtonHidden()
        .padding()
    }
}

#Preview {
    WelcomeView(isPresented: .constant(true))
}
