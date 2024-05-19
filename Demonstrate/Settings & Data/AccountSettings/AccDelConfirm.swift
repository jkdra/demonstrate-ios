//
//  AccDelConfirm.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI
import Supabase

struct AccDelConfirm: View {
    
    @State private var confirmUsername = ""
    @State private var usernameToCompare = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 10) {
                Text("Woah! slow down...")
                    .foregroundStyle(.red)
                    .largeTitle()
                
                Text("Are you sure you know what you're doing?")
                    .headline()
                
                Label("**ALL** content associated with your account ever made will be deleted. This includes signatues, comments, and endorsements.", systemImage: "exclamationmark.triangle.fill")
                    .footnotePage()
                
                Label("This is irreversable. We CANNOT bring back your account.", systemImage: "exclamationmark.triangle.fill")
                    .footnotePage()
                
                Label("You're doing something very stupid.", systemImage: "exclamationmark.triangle.fill")
                    .footnotePage()
                
                Spacer()
                
                Button("Delete Account") {
                    
                }
                .secondaryButton(destructive: true)
                .disableWithOpacity(confirmUsername != usernameToCompare)
            }
            .task { await fetchUsernameToCompare() }
            .overlay {
                TextField("Username", text: $confirmUsername, prompt: Text("Type username to confirm"))
                    .modifier(CustomTextFieldStyle())
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.custom("Unbounded", size: 14))
                }
            }
            .padding()
        }
        .tint(.red)
        
    }
    
    private func fetchUsernameToCompare() async {
        
        guard !confirmUsername.isEmpty else { return }
        
        do {
            let currentUser = try await auth.session.user
            
            let fetchedUsername: String = try await database.from("profiles")
                .select("username")
                .eq("id", value: currentUser.id)
                .execute()
                .value
            
            await MainActor.run {
                usernameToCompare = fetchedUsername
            }
        } catch {
            
        }
    }
}

#Preview {
    AccDelConfirm()
}
