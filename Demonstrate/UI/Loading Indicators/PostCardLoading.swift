//
//  PostCardLoading.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct PostCardLoading: View {
    var body: some View {
        VStack (alignment: .leading, spacing: 12){
            Capsule()
                .frame(width: 164, height: 20)
                .padding(.bottom, 8)
            
            ForEach(0..<3) { index in
                Capsule()
                    .frame(width: 256, height: 14)
            }
            
            Capsule()
                .frame(width: 164, height: 14)
                .padding(.top, 8)
            
            Divider()
            
            HStack (spacing: 10) {
                Circle()
                    .frame(width: 16, height: 16)
                
                Capsule()
                    .frame(width: 100,height: 12)
                
                Spacer()
                
                Capsule()
                    .frame(width: 100,height: 12)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground), in: .rect(cornerRadius: 14))
        .foregroundStyle(.tertiary)
        .overlay {
            ShimmerEffect()
                .mask {
                    VStack (alignment: .leading, spacing: 12){
                        Capsule()
                            .frame(width: 164, height: 20)
                            .padding(.bottom, 8)
                        
                        ForEach(0..<3) { index in
                            Capsule()
                                .frame(width: 256, height: 14)
                        }
                        
                        Capsule()
                            .frame(width: 164, height: 14)
                            .padding(.top, 8)
                        
                        Divider()
                        
                        HStack (spacing: 10) {
                            Circle()
                                .frame(width: 16, height: 16)
                            
                            Capsule()
                                .frame(width: 100,height: 12)
                            
                            Spacer()
                            
                            Capsule()
                                .frame(width: 100,height: 12)
                        }
                    }
                    .padding()
                }
        }
    }
}

#Preview {
    PostCardLoading()
}
