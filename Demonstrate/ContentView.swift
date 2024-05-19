//
//  ContentView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @Bindable var authViewModel = AuthenticationViewModel()
    
    var body: some View {
        MainView()
            .fullScreenCover(isPresented: $authViewModel.showOnboarding) {
                OnboardingScreen(isPresented: $authViewModel.showOnboarding)
            }
            .task { await authViewModel.isUserAuthenticated() }
    }
}

struct MainView: View {
    
    let tabs: [TabBarItem] = [.home, .activity, .newpost, .search, .profile]
    @State private var currentTab: TabBarItem = .home
    
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView()
                .tag(TabBarItem.home)
            
            Text("Activity")
                .tag(TabBarItem.activity)
            
            SearchView()
                .tag(TabBarItem.search)
            
            Text("Profile")
                .tag(TabBarItem.profile)
        }
        .overlay(alignment: .bottom) {
            TabBarView(tabs: tabs, selection: $currentTab, localSelection: currentTab)
        }
    }
}

#Preview {
    MainView()
}
