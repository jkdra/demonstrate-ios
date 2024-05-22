//
//  AccountSettingsView().swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI
import Supabase
import Auth

struct AccountSettingsView: View {
    
    @Bindable var authViewModel = AuthenticationViewModel()
    let pManagement = ProfileManagement()
    @State private var changeUsername = false
    @State private var confirmAccDeletion = false
    @State private var appleLinked = true
    @State private var googleLinked = true
    
    var body: some View {
        List {
            Section {
                NavigationLink("Change Username") { NewUsernameView() }
                
                NavigationLink("Change Email") {
                    
                }
                
                Button("Sign Out") { signOut() }
                
                
                
            } header: {
                Text("General")
                    .font(.custom("Unbounded", size: 12))
            }
            
                Section {
                    HStack (spacing: 12){
                        Image("googlelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 16, height: 16)

                        Text("Google")

                        Spacer()
                        if !googleLinked {
                            Button("Link Account") {

                            }
                        } else {
                            Menu("Linked") {
                                Button("Unlink", role: .destructive) {

                                }
                            }
                            .foregroundStyle(.secondary)
                        }
                    }

                    HStack (spacing: 16){
                        Image(systemName: "applelogo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 14, height: 14)

                        Text("Apple")

                        Spacer()

                        if !appleLinked {
                            Button("Link Account") { appleLinked = true }
                        } else {
                            Menu("Linked") {
                                Button("Unlink", role: .destructive) { appleLinked = false }
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Linked Accounts")
                        .font(.custom("Unbounded", size: 12))
                }
            
            Section {
                Button("Delete Account", role: .destructive) { confirmAccDeletion = true }
            } header: {
                Text("Danger Zone")
                    .font(.custom("Unbounded", size: 12))
            }
            .task { await fetchIdentities() }
        }
        .customNavBar("Account")
        .font(.custom("Unbounded", size: 14))
        .overlay {FullscreenLoading(show: $authViewModel.loading)}
        .alert("Oop!", isPresented: $authViewModel.error) {} message: { Text(authViewModel.errorMsg) }
        .sheet(isPresented: $confirmAccDeletion) { AccDelConfirm() }
        
    }
    
    private func signOut() { Task { await authViewModel.signOut() } }
    
    private func fetchIdentities() async {
        do {
            let identities = try await auth.userIdentities()
            googleLinked = identities.contains { $0.provider == "google" }
            appleLinked = identities.contains { $0.provider == "google" }
        } catch {
            
        }
    }
    
//    private func fetchIdentities() async {
//        do {
//            let identities = try await supabase.auth.userIdentities()
//            
//            print("\(identities)")
//            
//            if identities.contains(where: { identity in
//                identity.provider == Provider.google.rawValue
//            }) {
//                googleLinked = true
//            }
//            
//            if identities.contains(where: { identity in
//                identity.provider == "apple"
//            }) {
//                appleLinked = true
//            }
//            
//            if identities.contains(where: { identity in
//                identity.provider == Provider.apple.rawValue
//            }) {
//                appleLinked = true
//            }
//        } catch {
//            print("")
//        }
//    }
}

#Preview {
    AccountSettingsView()
}
