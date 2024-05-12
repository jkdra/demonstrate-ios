//
//  ProfileDetailView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import Supabase

struct ProfileDetailView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .center, spacing: 10) {
                        Circle()
                            .frame(width: 84, height: 84)
                        
                        VStack (alignment: .leading, spacing: 4) {
                            Text("Display Name")
                                .modifier(CustomTitlePostCard())
                            
                            Text("username")
                                .modifier(CustomBodyPostCard())
                            
                            HStack(spacing: 10) {
                                Text("**0** Followers")
                                    
                                Divider()
                                    .padding(.vertical, 6)
                                
                                Text("**0** Following")
                            }
                            .foregroundStyle(.primary)
                            .modifier(CustomBodyPostCard())
                        }
                    }
                    
                    Button("Follow", systemImage: "plus.circle.fill") {
                        
                    }
                    .primaryButton()
                    
                    Text("Biography\n")
                        .modifier(CustomBodyPostCard())
                    
                    
                }
                .padding()
            }
            .customNavBar("Display Name")
        }
    }
}

@Observable
class ProfileDetailsViewModel {
    
    
    
    
}

#Preview {
    ProfileDetailView()
}
