//
//  ConfirmSignView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/16/24.
//

import SwiftUI

enum SignatureMethod { case draw, type }


struct ConfirmSignView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var signMethod: SignatureMethod = .draw
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                
                Button("Sign this Petition") {
                    
                }
                .primaryButton()
            }
            .safeAreaPadding()
            .customNavBar("Sign Petition")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.custom("Unbounded", size: 14))
                }
            }
        }
    }
    
    func signPetiton() {
        
    }
}

#Preview {
    ConfirmSignView()
}
