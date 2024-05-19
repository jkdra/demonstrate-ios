//
//  SignInView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI

struct SignInView: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    @Binding var isPresented: Bool
    @State private var showPassword = false
    @State private var checkEmail = false
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            
            Text("Welcome Back!")
                .largeTitle()
            
            Text("Now quickly, let's get you back in.")
                .headline()
            
            Spacer()
            Button("Sign In") { AppSettingsManager.shared.primaryButtonHaptic(); signIn() }
                .primaryButton()
                .disableWithOpacity(email.isEmpty || password.isEmpty)
        }
        .overlay {
            VStack {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .modifier(CustomTextFieldStyle())
                
                Group {
                    if !showPassword {
                        SecureField("Password", text: $password)
                            
                    } else {
                        TextField("Password", text: $password)
                    }
                }
                .textContentType(.password)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .modifier(CustomTextFieldStyle())
                .overlay(alignment: .trailing) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                        .padding(.trailing)
                        .onTapGesture { showPassword.toggle() }
                }
                Button("Reset password") { resetPass() }
                    .hAlign(.trailing)
                    .font(.custom("Unbounded", size: 14))
                    .padding(.vertical, 8)
            }
        }
        .alert("Oh shit!", isPresented: $viewModel.error, actions: {}) { Text(viewModel.errorMsg) }
        .alert("Check your inbox", isPresented: $checkEmail) {} message: { Text("We sent an email with instructions to change your password.") }
        .padding()
        .overlay { FullscreenLoading(show: $viewModel.loading)}
    }
    
    func signIn() {
        Task {
            await viewModel.signIn(email: email, password: password)
        }
    }
    
    func resetPass() {
        Task {
            await viewModel.resetPassword(email: email)
        }
    }
}


#Preview {
    SignInView(isPresented: .constant(true))
}
