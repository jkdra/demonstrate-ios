//
//  TopicView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/14/24.
//

import SwiftUI
import Supabase

struct TopicView: View {
    
    let topic: Topic
    @State private var topicPosts = [any Post]()
    @State private var fetching = true
    
    var body: some View {
        NavigationStack{
            ScrollView {
                Section {
                    if fetching {
                        ForEach(0..<5) { _ in
                            PostCardLoading()
                        }
                    } else if !topicPosts.isEmpty {
                        ForEach(topicPosts, id: \.id) { post in
                            PostCard(post: post)
                        }
                    }
                } header: {
                    Text("Posts for \(topic.title):")
                        .sectionHeader()
                        .padding(.top)
                }
                
            }
            .customNavBar(topic.title)
            .overlay {
                if topicPosts.isEmpty && !fetching {
                    ContentUnavailableView {
                        Label("No posts found", systemImage: "questionmark.circle.fill")
                            .titleCard()
                    } description: {
                        Text("There doesn't seem to be any posts for this topic yet...")
                            .bodyCard()
                            .padding(.top, 6)
                    }
                }
            }
            .disabled(fetching)
            .disabled(topicPosts.isEmpty)
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .task { await fetchPosts() }
            .background {
                LinearGradient(colors: [topic.colorHex.opacity(0.75), .clear], startPoint: .top, endPoint: .center)
                    .ignoresSafeArea()
            }
        }
    }
    
    @MainActor
    func fetchPosts() async {
        defer { fetching = false }
        do {
            let fetched: [Petition] = try await database.from("petitions")
                .select()
                .eq("topic", value: topic.rawValue)
                .order("created_at", ascending: false)
                .execute()
                .value
            
            topicPosts = fetched
        } catch {
            print("ERROR FETCHING: \(error.localizedDescription)")
        }
    }
}

#Preview {
    TopicView(topic: .other)
}
