//
//  AccountSettingsView().swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct AccountSettingsView: View {
    
    @Bindable var authViewModel = AuthenticationViewModel()
    let pManagement = ProfileManagement()
    @State private var confirmAccDeletion = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Change Username") { NewUsernameView() }
                        .onTapGesture {
                            AppSettingsManager.shared.primaryButtonHaptic()
                        }
                    
                    NavigationLink("Change Email") {
                        
                    }
                    .onTapGesture { AppSettingsManager.shared.primaryButtonHaptic() }
                    
                    Button("Sign Out") { signOut() }
                    
                    
                    
                } header: {
                    Text("General")
                        .font(.custom("Unbounded", size: 12))
                }
                
                Section {
                    Button("Delete Account", role: .destructive) {
                        AppSettingsManager.shared.primaryButtonHaptic()
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
        .overlay {FullscreenLoading(show: $authViewModel.loading)}
        .alert("Oop!", isPresented: $authViewModel.error) {} message: { Text(authViewModel.errorMsg) }
        .sheet(isPresented: $confirmAccDeletion) { AccDelConfirm() }
    }
    
    private func signOut() {
        Task {
            await authViewModel.signOut()
        }
    }
}

#Preview {
    AccountSettingsView()
}
