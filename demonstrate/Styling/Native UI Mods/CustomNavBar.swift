//
//  CustomNavBar.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/14/25.
//

import SwiftUI
import UIKit

/*
 This Modifier applies the custom font to the navigation bar to add consistency throughout the app.
 */
public struct CustomNavigationBar: ViewModifier {
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        
        // Safely load the custom fonts with fallbacks
        let largeTitleFont = UIFont(name: "Unbounded-Regular_Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        let titleFont = UIFont(name: "Unbounded-Regular_Medium", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        let buttonFont = UIFont(name: "Unbounded-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        
        // Set attributes for large titles and regular titles
        navigationBarAppearance.largeTitleTextAttributes = [.font: largeTitleFont]
        navigationBarAppearance.titleTextAttributes = [.font: titleFont]
        
        let fontAttr = [NSAttributedString.Key.font: buttonFont]
        
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = fontAttr
        
        navigationBarAppearance.buttonAppearance = buttonAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: titleFont], for: .normal)

        // Apply the appearance to standard and compact navigation bars
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    }
    
    public func body(content: Content) -> some View {content}
}

public struct TintedNavigationBar: ViewModifier {
    
    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        
        // Safely load the custom fonts with fallbacks
        let largeTitleFont = UIFont(name: "Unbounded-Regular_Black", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .black)
        let titleFont = UIFont(name: "Unbounded-Regular_Medium", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        let buttonFont = UIFont(name: "Unbounded-Regular", size: 14) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
        
        // Set attributes for large titles and regular titles
        navigationBarAppearance.largeTitleTextAttributes = [.font: largeTitleFont, .foregroundColor: UIColor.accent]
        navigationBarAppearance.titleTextAttributes = [.font: titleFont]
        
        let fontAttr = [NSAttributedString.Key.font: buttonFont]
        
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = fontAttr
        
        navigationBarAppearance.buttonAppearance = buttonAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: titleFont], for: .normal)

        // Apply the appearance to standard and compact navigation bars
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
    }
    
    public func body(content: Content) -> some View { content }
}

extension View {
    func customNavBar(_ title: String) -> some View {
        self
            .modifier(CustomNavigationBar())
            .navigationTitle(title)
    }
    
    func tintedNavBar(_ title: String) -> some View {
        self
            .modifier(TintedNavigationBar())
            .navigationTitle(title)
    }
}

