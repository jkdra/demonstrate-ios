//
//  OAuthUsername.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct OAuthUsername: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    @State private var usernameCheck: UsernameCheckStatus = .idle
    @State private var username = ""
    @FocusState var focus
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("Welcome to the movement!")
                .largeTitle()
            
            Text("Looks like you used 3rd party sign up! You still need your username though, so uh, fix that.")
                .subtitle()
            
            Spacer()
            
            Button("Set Username") {
                
            }
            .primaryButton()
            .disableWithOpacity(usernameCheck != .available)
        }
        .navigationBarBackButtonHidden()
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
            }
        }
        .padding()
    }
    
    func setUsername() {
        Task {
            do {
                try await ProfileManagement().updateUsername(newUsername: username)
            } catch {
                print("ERROR SETTING USERNAME: \(error.localizedDescription)")
            }
        }
    }
    
    func checkUsername() {
        viewModel.checkUsername(usernameInput: username) { usernameCheck = $0 }
    }
}

#Preview {
    OAuthUsername()
}
