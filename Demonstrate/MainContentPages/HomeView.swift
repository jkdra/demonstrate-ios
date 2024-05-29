//
//  HomeView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/15/24.
//

import SwiftUI
import Supabase

struct HomeView: View {
    
    let viewModel = HomeViewModel()
    @ObserveInjection var inject
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if !viewModel.fetching {
                                ForEach(viewModel.postCarousel) { post in
                                    FeaturedPostCard()
                                        .scrollTransition { content, phase in
                                            content
                                                .opacity(phase.isIdentity ? 1 : 0.5)
                                                .scaleEffect(phase.isIdentity ? 1 : 0.98)
                                        }
                                }
                            } else {
                                ForEach(0..<2) { _ in FeaturedCardLoading() }
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                    
                    Section {
                        if viewModel.fetching {
                            ForEach(0..<3) { _ in PostCardLoading() }
                        } else if !viewModel.postFeedVert.isEmpty {
                            ForEach(viewModel.postFeedVert) { PostCard(post: $0) }
                        } else {
                            ContentUnavailableView {
                                Label("No Posts Found", systemImage: "square.stack.3d.up.slash.fill")
                                    .titleCard()
                            } description: {
                                Text("There was an issue fetching posts... Or you're simply the first one on this app!")
                                    .bodyCard()
                                    .padding(.top, 6)
                            }
                        }
                        
                    } header: {
                        Text("Latest Movements")
                            .sectionHeader()
                            .padding(.top)
                    }
                }
                .safeAreaPadding()
            }
            .disabled(viewModel.fetching)
            .customNavBar("Home")
            .task { await viewModel.fetchPosts(); await viewModel.fetchCarousel() }
        }
        .enableInjection()
    }
}

@Observable
class HomeViewModel {
    var fetching = false
    var postFeedVert = [Petition]()
    var postCarousel = [Petition]()
    
    @MainActor
    func fetchPosts() async {
        do {
            let foundPosts: [Petition] = try await database.from("petitions")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            postFeedVert = foundPosts
        } catch {
            print("ERROR FETCHING: \(error)")
        }
    }
    
    @MainActor
    func fetchCarousel() async {
        do {
            let foundPosts: [Petition] = try await database.from("petitions")
                .select()
                .order("created_at", ascending: false)
                .execute()
                .value
            
            postCarousel = foundPosts
        } catch {
            print("ERROR FETCHING: \(error)")
        }
    }
}

#Preview {
    HomeView()
}
