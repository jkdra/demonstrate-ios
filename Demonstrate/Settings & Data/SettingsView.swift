//
//  SettingsView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct SettingsView: View {
    
    @State private var themeChoices: [AppTheme] = [.system, .light, .dark]
    @Environment(\.dismiss) private var dismiss
    @Bindable var settingsManager = AppSettingsManager()
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("App Theme", selection: $settingsManager.appTheme) {
                        Text("System").tag(AppTheme.system)
                        Text("Light").tag(AppTheme.light)
                        Text("Dark").tag(AppTheme.dark)
                        }
                    
                    HStack {
                        Text("App Icons")
                        Spacer()
                        Text("Future Update!")
                            .foregroundStyle(.secondary)
                    }
                    
                    HStack {
                        Text("Notifications")
                        Spacer()
                        Text("Future Update!")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("App Settings")
                        .font(.custom("Unbounded", size: 12))
                }
                
                Section {
                    HStack {
                        Text("Username")
                        Spacer()
                        Text("username")
                            .foregroundStyle(.secondary)
                    }
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(verbatim: "demo@email.com")
                            .foregroundStyle(.secondary)
                    }
                    
                    NavigationLink("Account Settings") { AccountSettingsView() }
                    
                } header: {
                    Text("Account")
                        .font(.custom("Unbounded", size: 12))
                }
                    
            }
            .customNavBar("Settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
//            .toolbarTitleDisplayMode(.inline)
            .font(.custom("Unbounded", size: 14))
            .preferredColorScheme(settingsManager.appTheme.themePreference)
        }
    }
}

#Preview {
    SettingsView()
}
