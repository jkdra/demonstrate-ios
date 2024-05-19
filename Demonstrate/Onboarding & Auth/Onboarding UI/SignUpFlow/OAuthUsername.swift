//
//  OAuthUsername.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct OAuthUsername: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    
    @Binding var isPresented: Bool
    @State private var success = false
    @State private var usernameCheck: UsernameCheckStatus = .idle
    @State private var username = ""
    @FocusState var focus
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Welcome to the movement!")
                .largeTitle()
            
            Text("3rd Party sign in, how convenient!\n\nIt'd also be convenient for you to have a username, please.")
                .headline()
            
            Spacer()
            
            
            Button("Set Username") {
                AppSettingsManager().primaryButtonHaptic()
                setUsername()
            }
                .primaryButton()
                .disableWithOpacity(usernameCheck != .available)
        }
        .navigationBarBackButtonHidden()
        .navigationDestination(isPresented: $success) { CreateProfileView(isPresented: $isPresented) }
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
                            if usernameCheck == .checking {
                                ProgressView()
                            } else if usernameCheck == .available {
                                Image(systemName: "checkmark.circle.fill")
                            } else if usernameCheck != .idle {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .foregroundStyle(usernameCheck.statusColor ?? .primary)
                        .bold()
                        .padding(.trailing)
                        
                    }
                    .onChange(of: username) {
                        usernameCheck = .checking
                        username.isEmpty ? usernameCheck = .idle : checkUsername()
                    }
            }
        }
        .padding()
    }
    
    func setUsername() {
        
        focus = false
        
        Task {
            await ProfileManagement().updateUsername(newUsername: username)
            success = true
        }
    }
    
    @MainActor
    func checkUsername() { viewModel.checkUsername(usernameInput: username) { usernameCheck = $0 } }
}

#Preview {
    OAuthUsername(isPresented: .constant(true))
}
