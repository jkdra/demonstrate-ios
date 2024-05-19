//
//  HomeView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/15/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 10) {
                
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<5) { _ in
                                FeaturedPostCard()
                                    .scrollTransition { content, phase in
                                        content
                                            .opacity(phase.isIdentity ? 1 : 0.5)
                                            .scaleEffect(phase.isIdentity ? 1 : 0.98)
                                    }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    
                    Section {
                        ForEach(0..<5) { _ in
                            PostCard()
                        }
                    } header: {
                        Text("Latest Movements")
                            .sectionHeader()
                            .padding(.top)
                    }
                }
                .safeAreaPadding()
            }
            .customNavBar("Home")
        }
    }
}

#Preview {
    HomeView()
}
