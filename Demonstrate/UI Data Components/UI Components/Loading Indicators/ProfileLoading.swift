//
//  ProfileLoading.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct ProfileLoading: View {
    var body: some View {
        NavigationStack {
            ShimmerEffect()
                .customNavBar("___")
                .mask {
                    ScrollView {
                        VStack (alignment: .leading, spacing: 12) {
                            HStack (spacing: 12){
                                Circle()
                                    .frame(width: 84, height: 84)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Capsule()
                                        .frame(width: 164, height: 20)
                                    
                                    Capsule()
                                        .frame(width: 124, height: 14)
                                    
                                    HStack {
                                        Capsule()
                                            .frame(width: 92, height: 12)
                                        
                                        Divider()
                                        
                                        Capsule()
                                            .frame(width: 92, height: 12)
                                    }
                                }
                            }
                            
                            Button("") {
                                
                            }
                            .primaryButton()
                            
                            ForEach(0..<3) { index in
                                Capsule()
                                    .frame(width: 256 / (CGFloat(index) * 1), height: 14)
                            }
                            
                            ForEach(0..<3) { index in
                                PostCardLoading()
                            }
                        }
                        .safeAreaPadding(.top, 142)
                    }
                    .disabled(true)
                    .padding()
                }
                .ignoresSafeArea()
                
        }
    }
}

#Preview {
    ProfileLoading()
}
