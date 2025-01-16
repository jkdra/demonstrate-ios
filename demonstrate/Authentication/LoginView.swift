//
//  LoginView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack (alignment: .leading) {
            Text("Looks like you already have an account!")
                .fontStyle(.headline)
                .opacity(0.5)
            
            Spacer()
            
            Button("Forgot Password?") {
                
            }
            .tertiaryButton()
            
            Button("Continue") {
                
            }
            .primaryButton()
        }
        .customNavBar("Welcome Back!")
        .safeAreaPadding(.horizontal)
        .safeAreaPadding(.bottom)
    }
}

#Preview {
    LoginView()
}
