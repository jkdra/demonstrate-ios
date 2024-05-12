//
//  Buttons.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import SwiftUI

extension View {
    func primaryButton() -> some View {
        self.buttonStyle(PrimaryButtonStyle())
    }
    
    func secondaryButton(maximizeWidth: Bool = true) -> some View {
        self.buttonStyle(SecondaryButtonStyle(maximizeWidth: maximizeWidth))
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    
    var destructiveContext: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Unbounded-Regular_Semibold", size: 14))
            .foregroundStyle(Color(uiColor: .systemBackground))
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonAccent(), in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(buttonAccent())
                    .brightness(0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .top, endPoint: .bottom)
                    }
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(buttonAccent())
                    .brightness(-0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .bottom, endPoint: .top)
                    }
            }
            .clipShape(.rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
    
    func buttonAccent() -> Color {
        if destructiveContext {
            return .red
        } else {
            return .accentColor
        }
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    
    var destructiveContext: Bool = false
    var maximizeWidth: Bool = true
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Unbounded-Regular_Semibold", size: 14))
            .foregroundStyle(destructiveContext ? .red : .accentColor)
            .frame(maxWidth: maximizeWidth ? .infinity : nil)
            .padding()
            .background(.gray.opacity(0.25), in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white.opacity(0.2), .black.opacity(0.15)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
            }
            .clipShape(.rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct AppleSignInButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Unbounded-Regular_Semibold", size: 14))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray.opacity(0.2), in: .rect(cornerRadius: 14))
            .background(.black, in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(.white.opacity(0.2))
                    .brightness(0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .top, endPoint: .bottom)
                    }
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .brightness(0.2)
                    .foregroundStyle(.black)
                    .brightness(-0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .bottom, endPoint: .top)
                    }
            }
            .clipShape(.rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct GoogleSignInButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("Unbounded-Regular_Semibold", size: 14))
            .foregroundStyle(.black)
            .frame(maxWidth: .infinity)
            .padding()
            .background(.gray.opacity(0.2), in: .rect(cornerRadius: 14))
            .background(.white, in: .rect(cornerRadius: 14))
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(.white.opacity(0.2))
                    .brightness(0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .top, endPoint: .bottom)
                    }
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .brightness(0.2)
                    .foregroundStyle(.black.opacity(0.2))
                    .brightness(-0.2)
                    .mask {
                        LinearGradient(colors: [.accentColor, .clear], startPoint: .bottom, endPoint: .top)
                    }
            }
            .clipShape(.rect(cornerRadius: 14))
            .opacity(configuration.isPressed ? 0.8 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
