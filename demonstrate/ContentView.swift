//
//  ContentView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/13/25.
//

import SwiftUI
import Network

enum NetworkStatus {
    case connecting, connected, unavailable, disabled
}

struct ContentView: View {
    
    @State private var showReload = false
    @Bindable private var errorHandler = ErrorHandler()
    @State private var netState: NetworkStatus = .connecting
    private let monitor = NWPathMonitor()
    
    var body: some View {
        Group {
            if netState == .connected {
                NavigationStack {
                    ScrollView {
                        NavigationLink("Tap to next screen") {
                            ScrollView {
                                
                            }
                            .customNavBar("Hello")
                            .navigationBarTitleDisplayMode(.large)
                            .toolbar {
                                
                                
                                ToolbarItemGroup(placement: .primaryAction) {
                                    Menu("Test", systemImage: "ellipsis"){
                                        Button("One", systemImage: "square") {
                                            
                                        }
                                        Button("Two", systemImage: "circle") {
                                            
                                        }
                                        Button("Three", systemImage: "triangle") {
                                            
                                        }
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .customNavBar("Test Reload")
                    .refreshable { showReload = true }
                    .overlay { TintWave(trigger: $showReload) }
                    .toolbar {
                        
                        ToolbarItem(placement: .primaryAction) {
                            Button("Share", systemImage: "square.and.arrow.up") {
                                
                            }
                        }
                        
                        if #available(iOS 26.0, *) { ToolbarSpacer(.fixed, placement: .primaryAction) }
                        
                        ToolbarItemGroup(placement: .primaryAction) {
                            Menu("Test", systemImage: "ellipsis"){
                                Button("One", systemImage: "square") {
                                    
                                }
                                Button("Two", systemImage: "circle") {
                                    
                                }
                                Button("Three", systemImage: "triangle") {
                                    
                                }
                            }
                        }
                    }
        
                }
//                    .task { await authViewModel.isUserAuthenticated() }
                //                    .fullScreenCover(isPresented: $authViewModel.showOnboarding) {
                //                        OnboardingScreen(isPresented: $authViewModel.showOnboarding)
                //                    }
//                    .alert(isPresented: $errorHandler.errorOccured, error: errorHandler.currentError) { _ in } message: { err in
//                        Text(err.errorLongDesctription)
//                    }
            } else {
                ContentUnavailableView {
                    Label("Uhh, internet? Hello?", systemImage: "network.slash")
                        .font(.custom("Unbounded-Regular_Bold", size: 20))
                        .fontStyle(.title)
                } description: {
                    Text("Do you seriously think you can use this app without internet?")
                        .padding(.top)
                        .fontStyle(.caption)
                    Button("Retry", systemImage: "arrow.triangle.2.circlepath") { internetHandler() }
                        .primaryButton()
                }
            }
        }
        .onAppear{ internetHandler() }
    }
    
    // To check the internet status of the device
    private func internetHandler() {
        netState = .connecting
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                switch path.status {
                case .satisfied:  // If internet is found
                    print("Internet Connection Established!")
                    netState = .connected
                case .unsatisfied: // If there's no internet
                    print("No Internet Connection!")
                    netState = .unavailable
                case .requiresConnection: // If the user doesn't have their internet on
                    print("User needs to enable internet.")
                    netState = .disabled
                @unknown default: break
                }
            }
        }
    }
    
}

#Preview {
    ContentView()
}
