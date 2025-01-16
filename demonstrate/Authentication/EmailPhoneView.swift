//
//  EmailPhoneView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI

struct EmailPhoneView: View {
    
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var textStatusColor: Color = .secondary
    @State private var enteringEmail = false
    @State private var loading = false
    @State private var continueEnabled = false
    @State private var emailInput = ""
    @State private var numberInput = ""
    
    var body: some View {
        VStack (alignment: .leading) {
            
            Text("This section is pretty self-explanitory.")
                .fontStyle(.headline)
                .opacity(0.5)
            
            Group {
                enteringEmail
                ? TextInput("example@email.com", text: $emailInput, color: textStatusColor)
                : TextInput("(123) 456-7890", text: $numberInput, color: textStatusColor)
            }
            .textContentType(enteringEmail ? .emailAddress : .telephoneNumber)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .vAlign(.center)
            
            Button(enteringEmail ? "Using Phone Number?" : "Using Email?") {
                withAnimation(.smooth(duration: 0.1)) { enteringEmail.toggle() }
            }
            .tertiaryButton()
            
            Button {
                withAnimation(.smooth(duration: 0.1)) { loading = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.smooth(duration: 0.1)) {
                        loading = false
                        continueEnabled = true
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    if loading {
                        ProgressView()
                            .frame(width: 18, height: 18)
                            .tint(Color(uiColor: .systemBackground))
                    }
                    Text("Continue")
                }
            }
            .onChange(of: enteringEmail) { emailInput = ""; numberInput = "" }
            .disableWithOpacity(emailInput.isEmpty && numberInput.isEmpty)
            .primaryButton()
        }
        .navigationDestination(isPresented: $continueEnabled) { SignUpView(usingEmail: enteringEmail) }
        .customNavBar(enteringEmail ? "Enter Email" : "Enter Phone")
        .safeAreaPadding(.horizontal)
        .disabled(loading)
        .safeAreaPadding(.bottom)
    }
}

#Preview {
    EmailPhoneView()
}
