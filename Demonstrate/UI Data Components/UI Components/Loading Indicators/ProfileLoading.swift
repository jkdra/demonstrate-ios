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
            ScrollView {
                VStack (alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .frame(width: 84, height: 84)
                        
                        VStack (alignment: .leading) {
                            Capsule()
                                .frame(width: 164, height: 20)
                            
                            Capsule()
                                .frame(width: 124, height: 14)
                            
                            HStack {
                                Capsule()
                                    .frame(width: 92, height: 12)
                                
                                Divider()
                                    .frame(height: 24)
                                
                                Capsule()
                                    .frame(width: 92, height: 12)
                            }
                        }
                    }
                    
                    Button(" ") {
                        
                    }
                    .primaryButton()
                    
                    ForEach(1..<4) { index in
                        Capsule()
                            .frame(width: 284 / Double(index), height: 14)
                    }
                    
                    Section {
                        ForEach(0..<5) { _ in PostCard() }
                    } header: {
                        Capsule()
                            .frame(width: 256, height: 14)
                            .padding(.top)
                    }
                    
                }
                .opacity(0)
                .overlay {
                    ShimmerEffect()
                        .mask {
                            ScrollView {
                                VStack (alignment: .leading, spacing: 12) {
                                    HStack {
                                        Circle()
                                            .frame(width: 84, height: 84)
                                        
                                        VStack (alignment: .leading) {
                                            Capsule()
                                                .frame(width: 164, height: 20)
                                            
                                            Capsule()
                                                .frame(width: 124, height: 14)
                                            
                                            HStack {
                                                Capsule()
                                                    .frame(width: 92, height: 12)
                                                
                                                Divider()
                                                    .frame(height: 24)
                                                
                                                Capsule()
                                                    .frame(width: 92, height: 12)
                                            }
                                        }
                                    }
                                    
                                    Button(" ") {
                                        
                                    }
                                    .primaryButton()
                                    
                                    ForEach(1..<4) { index in
                                        Capsule()
                                            .frame(width: 284 / CGFloat(index), height: 14)
                                    }
                                    
                                    Section {
                                        ForEach(0..<5) { _ in PostCard() }
                                    } header: {
                                        Capsule()
                                            .frame(width: 256, height: 14)
                                            .padding(.top)
                                    }
                                    
                                }
                            }
                        }
                }
                .safeAreaPadding()
            }
            .customNavBar("___")
        }
    }
}

#Preview {
    ProfileLoading()
}
