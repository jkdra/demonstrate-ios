//
//  NewUsernameView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI
import Supabase

struct NewUsernameView: View {
    
    let authViewModel = AuthenticationViewModel()
    let profileManagement = ProfileManagement()
    
    @Environment(\.dismiss) var dismiss
    @State private var usernameCheck: UsernameCheckStatus = .idle
    @State private var newUsernameInput = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Divider()
            Text("Bet, let's set something new, given no one else has taken it.")
                .headline()
            
            Spacer()
            
            Button("Set Username") { dismiss() }
                .primaryButton()
                .disableWithOpacity(usernameCheck != .available)
        }
        .customNavBar("Change Username")
        .overlay {
            VStack(spacing: 10){
                Text(usernameCheck != .idle ? usernameCheck.statusDisplay : " ")
                    .foregroundStyle(usernameCheck.statusColor ?? .primary)
                    .footnotePage()
                
                TextField("New Username", text: $newUsernameInput)
                    .textContentType(.username)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .modifier(CustomTextFieldStyle())
                    .overlay(alignment: .trailing) {
                        Group {
                            if usernameCheck == .available {
                                Image(systemName: "checkmark.circle.fill")
                            } else if usernameCheck == .checking {
                                ProgressView()
                            } else if usernameCheck != .idle {
                                Image(systemName: "xmark.circle.fill")
                            }
                        }
                        .font(.system(size: 20))
                        .bold()
                        .padding(.trailing)
                        
                    }
                    .foregroundStyle(usernameCheck.statusColor?.opacity(10) ?? .primary)
                
                Text(" ")
            }
        }
        .onChange(of: newUsernameInput) {
            usernameCheck = .checking
            if newUsernameInput.isEmpty {
                usernameCheck = .idle
            } else {
                checkUsername()
            }
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    @MainActor
    func checkUsername() {
        authViewModel.checkUsername(usernameInput: newUsernameInput) { usernameCheck = $0 }
    }
    
    func updateUsername() {
        Task {
            await profileManagement.updateUsername(newUsername: newUsernameInput)
            dismiss()
        }
    }
}

#Preview {
    NewUsernameView()
}
