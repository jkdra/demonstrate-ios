//
//  ContentView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import SwiftUI

struct ContentView: View {
    
    let authViewModel = AuthenticationViewModel()
    @State var showOnboarding = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .fullScreenCover(isPresented: $showOnboarding) { OnboardingScreen(isPresented: $showOnboarding) }
        .task {
            await authViewModel.isUserAuthenticated()
            showOnboarding = !authViewModel.isAuthenticated
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
