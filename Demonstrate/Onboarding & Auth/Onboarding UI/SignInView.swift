//
//  SignInView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI

struct SignInView: View {
    
    @Bindable var viewModel = AuthenticationViewModel()
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            
            Text("Welcome Back!")
                .largeTitle()
            
            Text("Now quickly, let's get you back in.")
                .subtitle()
            
            Spacer()
            Button("Sign In") {
                
            }
            .primaryButton()
            .disableWithOpacity(email.isEmpty || password.isEmpty)
        }
        .overlay {
            VStack {
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .autocorrectionDisabled()
                    .modifier(CustomTextFieldStyle())
                
                TextField("Password", text: $password)
                    .textContentType(.password)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .modifier(CustomTextFieldStyle())
                Button("Reset password") {
                    
                }
                .hAlign(.trailing)
                .font(.custom("Unbounded", size: 14))
                .padding(.vertical, 8)
            }
        }
        .padding()
        .overlay { FullscreenLoading(show: $viewModel.loading)}
    }
    
    func signIn() {
        Task {
            do {
                try await viewModel.signIn(email: email, password: password)
                
            } catch {
                print("ERROR SIGNING IN: \(error.localizedDescription)")
            }
        }
    }
}


#Preview {
    SignInView()
}
