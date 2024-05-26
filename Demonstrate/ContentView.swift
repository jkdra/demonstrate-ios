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
    @Bindable private var errorHandler = ErrorHandler()
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
                    .alert(isPresented: $errorHandler.errorOccured, error: errorHandler.currentError) { _ in } message: { err in
                        Text(err.errorLongDesctription)
                    }
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
            
            ContentUnavailableView {
                Label("Coming Soon!", systemImage: "bell.badge.fill")
                    .font(.custom("Unbounded", size: 16))
            } description: {
                Text("This page will be available in a future update! For now, feel free to test out the app!")
                    .font(.custom("Unbounded", size: 14))
                    .lineSpacing(4)
                    .padding(.top, 4)
            }
            .font(.custom("Unbounded", size: 14))
            .tag(TabBarItem.activity)
            
            VStack {
                Text("Oop- looks like you found a secret page!")
                
                Text("Now uh, navigate to a different page please...")
                    .foregroundStyle(.secondary)
                    .padding(.top)
            }
            .safeAreaPadding()
            .multilineTextAlignment(.center)
            .font(.custom("Unbounded", size: 16))
            .tag(TabBarItem.newPost)
            
            SearchView()
                .tag(TabBarItem.search)
            
            MyProfileView()
                .tag(TabBarItem.profile)
        }
        .overlay(alignment: .bottom) { TabBarView(tabs: tabs, selection: $currentTab, localSelection: currentTab) }
    }
}

#Preview { ContentView() }
