//
//  OnboardingScreen.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI

struct OnboardingScreen: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    @Binding var isPresented: Bool
    @State private var oauthSignUp: Bool = false
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
                                .font(.custom("Unbounded-Regular_Black", size: 56))
                                .foregroundStyle(.primary.opacity(0.085))
                                .frame(minWidth: 592)
                                .colorInvert()
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
        NavigationStack {
            VStack (alignment: .leading, spacing: 10) {
                VStack (alignment: .leading) {
                    Text("Welcome to")
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .largeTitle()
                    Text("DEMONSTRATE.")
                        .foregroundStyle(Color(uiColor: .systemBackground))
                        .font(.custom("Unbounded-Regular_Black", size: 28))
                        .largeTitle()
                }
                
                Text("Glad to know you're also sick of congress's bs.")
                    .foregroundStyle(.secondary)
                    .foregroundStyle(Color(uiColor: .systemBackground))
                    .headline()
                
                Spacer()
                
                Text("By signing up below, you agree to Demonstrate's **Community Guidelines**")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .modifier(FootnotePage())
                NavigationLink("Sign Up") {
                    SignUpView(isPresented: $isPresented)
                        .onAppear { viewModel.flow = .signUp }
                }
                .primaryButton()
                
                
                NavigationLink("Sign In") {
                    SignInView(isPresented: $isPresented)
                        .onAppear { viewModel.flow = .signIn }
                }
                .background(Color(uiColor: .systemBackground), in: .rect(cornerRadius: 14))
                .secondaryButton()
                
                Text("Or continue with:")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .modifier(FootnotePage())
                
                HStack {
                    
                    Button {
                        googleSignIn()
                    } label: {
                        HStack {
                            Image("googlelogo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 16, height: 16)
                            
                            Text("Google")
                        }
                    }
                    .buttonStyle(GoogleSignInButtonStyle())
                    
                    Button("Apple", systemImage: "applelogo") {
                        appleSignIn()
                    }
                    .buttonStyle(AppleSignInButtonStyle())
                }
            }
            .padding()
            .overlay { FullscreenLoading(show: $viewModel.loading) }
            .toolbar { ToolbarItem(placement: .primaryAction) { Text("") } }
            .navigationDestination(isPresented: $oauthSignUp) { OAuthUsername(isPresented: $isPresented) }
            .onChange(of: viewModel.flow) { if viewModel.flow == .signUpOAuth { oauthSignUp = true } }
            .background {
                LinearGradient(colors: [.accentColor, .clear], startPoint: .init(x: 0, y: 0.3), endPoint: .init(x: 0, y: 0.6))
                    .ignoresSafeArea()
                background
            }
        }
    }
    
    @MainActor 
    func googleSignIn() {
        viewModel.googleSignIn()
    }
    
    @MainActor 
    func appleSignIn() {
        viewModel.appleSignIn()
    }
}

#Preview {
    OnboardingScreen(isPresented: .constant(true))
}
