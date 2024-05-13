//
//  AccountSettingsView().swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct AccountSettingsView: View {
    
    let authViewModel = AuthenticationViewModel()
    let pManagement = ProfileManagement()
    @State private var confirmAccDeletion = false
    @State private var newEmailInput = ""
    
    var body: some View {
        NavigationStack {
            List {
                
                Section {
                    NavigationLink("Change Username") { NewUsernameView() }
                    
                    NavigationLink("Change Email") {
                        
                    }
                    
                    
//                    TextField("New Email", text: $newEmailInput)
//                        .textContentType(.emailAddress)
//                        .autocorrectionDisabled()
//                        .textInputAutocapitalization(.never)
                    
                } header: {
                    Text("General")
                        .font(.custom("Unbounded", size: 12))
                }
                
                Section {
                    Button("Delete Account", role: .destructive) {
                        confirmAccDeletion = true
                    }
                } header: {
                    Text("Danger Zone")
                        .font(.custom("Unbounded", size: 12))
                }
            }
            .customNavBar("Account")
        }
        .font(.custom("Unbounded", size: 14))
    }
}

#Preview {
    AccountSettingsView()
}
