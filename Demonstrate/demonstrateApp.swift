//
//  demonstrateApp.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/9/24.
//

import SwiftUI
import Nuke
import TipKit
import GoogleSignIn
@_exported import Inject

@main
struct demonstrateApp: App {
    
    init() {
        // For progressive image loading
        let pipeline = ImagePipeline { $0.isProgressiveDecodingEnabled = true }
        ImagePipeline.shared = pipeline
        
        Task { try? Tips.configure([.datastoreLocation(.applicationDefault)]) }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(AppSettingsManager().appTheme.themePreference)
                .onOpenURL { GIDSignIn.sharedInstance.handle($0) }
        }
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
      _ app: UIApplication,
      open url: URL,
      options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled { return true }
      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
    }
}
