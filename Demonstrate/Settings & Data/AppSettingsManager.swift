//
//  AppSettingsManager.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import Foundation
import SwiftUI

enum AppTheme: Codable {
    case light
    case dark
    case system
    
    var themePreference: ColorScheme? {
        switch self {
        case .light:
                .light
        case .dark:
                .dark
        case .system:
            nil
        }
    }
}

@Observable
final class AppSettingsManager {
    static let shared = AppSettingsManager()
    
    var haptics: Bool {
        didSet {
            UserDefaults.standard.set(haptics, forKey: "haptics")
        }
    }
    
    var appTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(appTheme), forKey: "appTheme")
        }
    }
    
    init() {
        // Set the default for haptics if not already stored
        if UserDefaults.standard.object(forKey: "haptics") == nil {
            UserDefaults.standard.set(true, forKey: "haptics")  // Default to true if not yet set
        }
        
        self.haptics = UserDefaults.standard.bool(forKey: "haptics")
        
        // Safe decoding of AppTheme or set to .system if not present
        if let data = UserDefaults.standard.data(forKey: "appTheme"),
            let decoded = try? PropertyListDecoder().decode(AppTheme.self, from: data) {
            self.appTheme = decoded
        } else {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(AppTheme.system), forKey: "appTheme")
            self.appTheme = .system
        }
    }
    
    let generator = UINotificationFeedbackGenerator()
    
    func successHaptic() {
        if haptics { generator.notificationOccurred(.success) }
    }
    
    func errorHaptic() {
        if haptics { generator.notificationOccurred(.error) }
    }
    
    func primaryButtonHaptic() {
        if haptics { UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 1) }
    }
}

let errorHaptic: () = AppSettingsManager.shared.errorHaptic()
let successHaptic: () = AppSettingsManager.shared.successHaptic()
