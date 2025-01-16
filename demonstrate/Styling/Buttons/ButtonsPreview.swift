//
//  ButtonsPreview.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/14/25.
//

import SwiftUI

struct ButtonsPreview: View {
    var body: some View {
        HStack {
            VStack {
                Button("Testing") {
                    
                }
                .primaryButton()
                
                Button("Testing") {
                    
                }
                .secondaryButton()
                
                Button("Testing") {
                    
                }
                .tertiaryButton()
            }
            
            VStack {
                Button("Testing") {
                    
                }
                .primaryButton(destructive: true)
                
                Button("Testing") {
                    
                }
                .secondaryButton(destructive: true)
                
                Button("Testing") {
                    
                }
                .tertiaryButton(destructive: true)
            }
        }
    }
}

#Preview {
    ButtonsPreview()
}
