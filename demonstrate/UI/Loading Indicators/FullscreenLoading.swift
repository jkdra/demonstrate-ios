//
//  FullscreenLoadingIndicator.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI

struct FullscreenLoading: View {
    
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            
            if show {
                ProgressView()
                    .tint(.accentColor)
                    .padding()
                    .background(Color(uiColor: .systemBackground), in: .circle)
                    .overlay {
                        Circle()
                            .stroke(lineWidth: 6)
                            .foregroundStyle(.tertiary)
                    }
                    .clipShape(.circle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black.opacity(0.2))
            }
                
        }
        
    }
}

#Preview {
    FullscreenLoading(show: .constant(false))
}
