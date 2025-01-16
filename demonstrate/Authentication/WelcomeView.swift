//
//  WelcomeView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/14/25.
//

import SwiftUI
import UIKit

struct WelcomeView: View {
    
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var animate = false
    private let columns = 8
    private let rows = 25
    
    var background: some View {
            GeometryReader { reader in
                VStack(spacing: 5) {
                    ForEach(0..<rows, id: \.self) { row in
                        HStack(spacing: 10) {
                            ForEach(0..<columns, id: \.self) { _ in
                                Text("DEMONSTRATE.")
                                    .font(.custom("Unbounded-Regular_Black", fixedSize: 56))
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                                    .frame(minWidth: 592)
                                    .opacity(0.085)
                            }
                        }
                        .offset(x: animate ? (row % 2 == 0 ? -reader.size.width * 2 : reader.size.width * 2) : 0, y: 0)
                        .offset(x: -1024)
                    }
                }
                .rotationEffect(.degrees(15))
            }
            .onAppear { withAnimation(Animation.linear(duration: 30).repeatForever(autoreverses: false)) { animate = true } }
        }
    
    var body: some View {
        
        let accessibilitySize = dynamicTypeSize.isAccessibilitySize
        
        NavigationStack {
            VStack (alignment: .center, spacing: 12) {
                
                Spacer()
                
                Group {
                    Image("demo.fill").font(.system(size: 132))
                    Text("Fuck Congress.").font(.custom("Unbounded-Regular_Bold", fixedSize: 32))
                }
                .foregroundStyle(Color(uiColor: .systemBackground))
                
                Spacer()
                
                NavigationLink("Sign In") { LoginView() }
                    .primaryButton()
                
                NavigationLink("Sign Up") { SignUpView(usingEmail: true) }
                    .secondaryButton()
                
                HStack {
                    if !accessibilitySize {
                        VStack { Divider() }
                        
                        Text("Or continue with:")
                            .fontStyle(.footnote)
                            .frame(width: 184)
                        
                        VStack { Divider() }
                    } else {
                        Text("Or continue with:")
                            .fontStyle(.footnote)
                    }
                    
                }
                
                let layout = dynamicTypeSize <= .accessibility1 ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
                
                layout {
                    Button("Apple", systemImage: "applelogo") {
                        
                    }
                    .buttonStyle(AppleButtonStyle())
                    
                    Button {
                        
                    } label: {
                        Label(
                            title: { Text("Google") },
                            icon: { Image("googlelogo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 16, height: 16)
                            }
                        )
                    }
                    .buttonStyle(GoogleButtonStyle())
                    
                }
                
            }
            .toolbarTitleDisplayMode(.large)
            .safeAreaPadding()
            .background {
                ZStack {
                    LinearGradient(colors: [Color.accentColor, Color.accentColor.opacity(0), Color.clear], startPoint: .init(x: 0, y: 0.55), endPoint: .init(x: 0, y: 0.95))
                    background
                }
                .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
