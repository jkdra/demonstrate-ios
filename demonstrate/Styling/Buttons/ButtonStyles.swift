//
//  ButtonStyles.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/14/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    
    let destructive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color(uiColor: .systemBackground))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
        
            .fontStyle(.subheadline)
            .padding()
            .background(!destructive ? Color.accentColor : .red)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom))
                    .opacity(0.4)
            }
            .clipShape(.rect(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    let destructive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(!destructive ? Color.accentColor : .red)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .fontStyle(.subheadline)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom))
                    .opacity(0.4)
            }
            .clipShape(.rect(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct AppleButtonStyle: ButtonStyle {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundStyle(.white)
            .fontStyle(.subheadline)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .environment(\.colorScheme, .dark)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom))
                    .opacity(0.4)
            }
            .clipShape(.rect(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct GoogleButtonStyle: ButtonStyle {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .foregroundStyle(.black)
            .fontStyle(.subheadline)
            .padding()
            .background(Color(uiColor: .secondarySystemBackground))
            .environment(\.colorScheme, .light)
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white, .black], startPoint: .top, endPoint: .bottom))
                    .opacity(0.4)
            }
            .clipShape(.rect(cornerRadius: 12))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}

struct TertiaryButtonStyle: ButtonStyle {
    
    let destructive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(!destructive ? Color.accentColor : .red)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .fontStyle(.subheadline)
            .padding(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.65 : 1)
    }
}

struct CircularPrimaryButtonStyle: ButtonStyle {
    
    let destructive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(Color(uiColor: .systemBackground))
            .fontStyle(.headline)
            .padding()
            .background(!destructive ? Color.accentColor : .red)
            .clipShape(.circle)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            
    }
}

struct CircularSecondaryButtonStyle: ButtonStyle {
    
    let destructive: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(!destructive ? Color.accentColor : .red)
            .fontStyle(.headline)
            .padding()
            .background(Color(uiColor: .systemBackground))
            .clipShape(.circle)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .opacity(configuration.isPressed ? 0.8 : 1)
            
    }
}

extension View {
    public func primaryButton(destructive: Bool = false) -> some View {
        self
            .buttonStyle(PrimaryButtonStyle(destructive: destructive))
    }
    
    public func secondaryButton(destructive: Bool = false) -> some View {
        self
            .buttonStyle(SecondaryButtonStyle(destructive: destructive))
    }
    
    public func tertiaryButton(destructive: Bool = false) -> some View {
        self
            .buttonStyle(TertiaryButtonStyle(destructive: destructive))
    }
    
    public func circlularPrimaryButton(destructive: Bool = false) -> some View {
        self
            .buttonStyle(CircularPrimaryButtonStyle(destructive: destructive))
    }
    
    public func circularSecondaryButton(destructive: Bool = false) -> some View {
        self
            .buttonStyle(CircularSecondaryButtonStyle(destructive: destructive))
    }
}
