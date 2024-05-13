//
//  demonstrateApp.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import SwiftUI
import UIKit
@_exported import Inject

@main
struct demonstrateApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppSettingsManager().appTheme.themePreference)
        }
    }
}
