//
//  MyProfileView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/21/24.
//

import SwiftUI
import Supabase

struct MyProfileView: View {
    
    @State private var id: UUID?
    @State private var settings = false
    
    var body: some View {
        NavigationStack {
            Group {
                if let id { ProfileDetailView(profileID: id) } else { ProfileLoading().disabled(true) }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Text("")
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button("Settings") { settings = true }
                        .sheet(isPresented: $settings) { SettingsView() }
                }
            }
        }
        .task { await fetchCurrentUser() }
    }
    
    private func fetchCurrentUser() async {
        do {
            let id = try await auth.session.user.id
            await MainActor.run { self.id = id }
        } catch {
            print("ERROR FETCHING ID: \(error.localizedDescription)")
            ErrorHandler().showError(error: .profile(.userProfileNotFound))
        }
    }
}

#Preview {
    MyProfileView()
}
