//
//  ContentView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import SwiftUI
import Network

enum NetworkStatus {
    case connecting
    case available
    case unavailable
    case internetOff
}

struct ContentView: View {
    
    @Bindable var authViewModel = AuthenticationViewModel()
    @State private var netState: NetworkStatus = .connecting
    let monitor = NWPathMonitor()
    
    var body: some View {
        Group {
            if netState == .available {
                MainView()
                    .task { await authViewModel.isUserAuthenticated() }
//                    .fullScreenCover(isPresented: $authViewModel.showOnboarding) {
//                        OnboardingScreen(isPresented: $authViewModel.showOnboarding)
//                    }
            } else {
                ContentUnavailableView {
                    Label("Uhh, internet? Hello?", systemImage: "network.slash")
                        .font(.custom("Unbounded-Regular_Bold", size: 20))
                        .titleCard()
                } description: {
                    Text("Do you seriously think you can use a social platform without internet?")
                        .padding(.top)
                        .bodyCard()
                    
                    Button("Retry", systemImage: "arrow.triangle.2.circlepath") { internetHandler() }
                        .primaryButton()
                        
                }
            }
        }
        .onAppear { internetHandler() }
    }
    
    private func internetHandler() {
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet Connection Established!")
                netState = .available
            } else if path.status == .unsatisfied {
                print("No Internet Connection!")
                netState = .unavailable
            } else {
                print("User needs to enable internet.")
                netState = .internetOff
            }
        }
    }
}

struct MainView: View {
    
    let tabs: [TabBarItem] = [.home, .activity, .newPost, .search, .profile]
    @State private var currentTab: TabBarItem = .home
    
    var body: some View {
        TabView(selection: $currentTab) {
            HomeView()
                .tag(TabBarItem.home)
            
            Text("Activity")
                .tag(TabBarItem.activity)
            
            SearchView()
                .tag(TabBarItem.search)
            
            MyProfileView()
                .tag(TabBarItem.profile)
        }
        .overlay(alignment: .bottom) { TabBarView(tabs: tabs, selection: $currentTab, localSelection: currentTab) }
    }
}

#Preview { ContentView() }
