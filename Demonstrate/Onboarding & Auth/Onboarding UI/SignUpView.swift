//
//  SignUpView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI
import Symbols

struct SignUpView: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    @State var usernameCheck: UsernameCheckStatus = .idle
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @FocusState var focus
    
    var body: some View {
        ZStack {
            
            VStack (alignment: .leading, spacing: 10) {
                Text(verbatim: "Welcome to the movement!")
                    .largeTitle()
                
                Text("We knew you'd be convinced eventually.")
                    .subtitle()
                
                Spacer()
                Button("Sign Up") {
                    signUpUser()
                }
                .primaryButton()
                .disableWithOpacity(usernameCheck != .available || email.isEmpty || password.isEmpty)
                
            }
            
        }
        .overlay {
            VStack {
                Text(usernameCheck.statusDisplay)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(usernameCheck.statusColor ?? .primary)
                    .footnotePage()
                
                TextField("Username", text: $username)
                    .textContentType(.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
                    .foregroundStyle(usernameCheck.statusColor?.opacity(10) ?? .primary)
                    .overlay(alignment: .trailing) {
                        Group {
                            if usernameCheck == .idle {
                                
                            } else if usernameCheck == .checking {
                                ProgressView()
                            } else if usernameCheck == .available {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.accent)
                                    .bold()
                            } else {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.red)
                                    .bold()
                                    
                            }
                        }
                        .padding(.trailing)
                        
                    }
                    .onChange(of: username) {
                        usernameCheck = .checking
                        username.isEmpty ? usernameCheck = .idle : checkUsername()
                    }
                
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
                
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
                .focused($focus)
                .overlay(alignment: .trailing) {
                    Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                        .foregroundStyle(.secondary)
                        .font(.headline)
                        .padding(.trailing)
                        .onTapGesture { showPassword.toggle() }
                }
                
                Text("Password should contain at least:\n• 6 characters\n• One upper & lowercase letter\n• One number and symbol")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .modifier(FootnotePage())
            }
        }
        .padding()
        .overlay { FullscreenLoading(show: $viewModel.loading)}
        
    }
    
    func signUpUser() {
        
        let pManage = ProfileManagement()
        
        Task {
            do {
                try await viewModel.signUp(email: email, password: password)
                try await pManage.updateUsername(newUsername: username)
            } catch {
                print("ERROR SIGNING IN: \(error.localizedDescription)")
            }
        }
    }
    
    func checkUsername() {
        viewModel.checkUsername(usernameInput: username) { usernameCheck = $0 }
    }
}

#Preview {
    SignUpView()
}