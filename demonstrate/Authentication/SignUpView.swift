//
//  SignUpView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI

struct SignUpView: View {
    
    let authModel = AuthenticationModel()
    
    var usingEmail: Bool
    
    @FocusState private var focusState: Bool
    @State private var showPassword = false
    @State private var emailValidityState: EmailValidityState = .empty
    @State private var emailInput: String = ""
    @State private var passwordInput: String = ""
    @State private var passwordStrength: Double = 0
    
    init(usingEmail: Bool) { self.usingEmail = usingEmail }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("You're new! Let's make sure you don't get hacked first.")
                .fontStyle(.headline)
                .opacity(0.5)
            
            Spacer()
            
            VStack (spacing: -2) {
                TextInput("Email", text: $emailInput, location: .top)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                Group {
                    if !showPassword { SecureInput("Password", text: $passwordInput, location: .bottom) }
                    else { TextInput("Password", text: $passwordInput, location: .bottom) }
                }
                .textContentType(.newPassword)
                .overlay (alignment: .trailing) {
                    Image(systemName: !showPassword ? "eye.fill" : "eye.slash.fill")
                        .onTapGesture { showPassword.toggle() }
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                        .padding(.trailing)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($focusState)
            
            ProgressView(value: Double(passwordStrength / 5))
                .tint(passwordStrength < 3 ? Color.red : (passwordStrength < 5 ? Color.orange : Color.accentColor))
            
            Text("Your Password should contain at least:\n• One uppercase and one lowercase letter.\n• One number and one symbol.\n• 12 characters in total.")
                .opacity(0.5)
                .fontStyle(.caption)
            
            Spacer()
            
            Text("By signing up below, you agree to the Terms of Service and Privacy Policy.")
                .multilineTextAlignment(.center)
                .fontStyle(.caption2)
                .hAlign(.center)
                .opacity(0.5)
            
            Button("Sign Up") {
                
            }
            .disabled(passwordStrength < 5 || emailInput.isEmpty)
            .primaryButton()
        }
        .onTapGesture { focusState = false }
        .safeAreaPadding(.horizontal)
        .safeAreaPadding(.bottom)
        .customNavBar("Welcome!")
        .onChange(of: passwordInput) {
            AuthenticationModel
                .checkPasswordStrength(passwordInput, score: $passwordStrength)
        }
    }
}

#Preview {
    SignUpView(usingEmail: true)
}
