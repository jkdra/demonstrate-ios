//
//  TopicView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/14/24.
//

import SwiftUI

struct TopicView: View {
    
    let topic: Topic
    @State var fetchedPosts: [any Post]?
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Section {
                    ForEach(0..<5) { _ in
                        PostCard()
                            .padding(.bottom, 2)
                    }
                } header: {
                    Text("Posts for \(topic.title):")
                        .sectionHeader()
                        .padding(.top)
                }
                
            }
            .customNavBar(topic.title)
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .background {
                LinearGradient(colors: [topic.colorHex.opacity(0.75), .clear], startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    TopicView(topic: .tech)
}
