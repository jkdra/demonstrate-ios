//
//  PostCard.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import Supabase

struct PostCard: View {
    
    let viewModel: PostCardViewModel
    
    init(post: any Post) {
        self.viewModel = PostCardViewModel(post: post)
    }
    
    var body: some View {
        
        let post = viewModel.post
        
        NavigationLink {
            
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                    .modifier(CustomTitlePostCard())
                
                Text(post.summary)
                    .lineLimit(3, reservesSpace: true)
                    .multilineTextAlignment(.leading)
                    .bodyCard()
                    .safeAreaPadding(.trailing, 48)
                
                Divider()
                HStack {
                    Circle()
                        .frame(width: 16, height: 16)
                    Text(viewModel.authorName)
                        .modifier(CustomFooterPostCard())
                    
                    Spacer()
                    
                    Label("Post Info", systemImage: "person.2.fill")
                        .bold()
                        .modifier(CustomFooterPostCard())
                }
            }
            .padding()
            .background(alignment: .trailing) {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(Color(uiColor: .secondarySystemBackground))
                Image("NoPFP")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2)
                    .mask {
                        RadialGradient(colors: [.white, .clear], center: .topTrailing, startRadius: 0, endRadius: 192)
                    }
                    .hAlign(.trailing)
                    
            }
            .clipShape(.rect(cornerRadius: 14))
        }
        .foregroundStyle(.primary)
        .task { await viewModel.fetchAuthorDetails() }
        .frame(maxWidth: 512)
        .overlay(alignment: .topTrailing) {
            Menu {
                if let userID = post.userID { NavigationLink("View Author") { ProfileDetailView(profileID: userID) } }
                Button("Report Post", role: .destructive) {
                    
                }
            } label: {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .bold()
                    .background(.regularMaterial, in: .circle)
                    .padding(.trailing, -6)
                    .padding(8)
            }
            .foregroundStyle(.primary)
        }
        .contextMenu {
            if let userID = post.userID { NavigationLink("View Author") { ProfileDetailView(profileID: userID) } }
            
            Button("Report Post", role: .destructive) {
                
            }
        }
    }
}

@Observable
class PostCardViewModel {
    var post: any Post
    var authorName = ""
    var authorImage = ""
    
    init(post: any Post) { self.post = post }
    
    @MainActor
    func fetchAuthorDetails() async {
        do {
            guard let userID = post.userID else { return }
            
            let baseQuery = database.from("profiles")
            
//            let profileImage: String = try await baseQuery.select("image_url")
//                .eq("id", value: userID)
//                .single()
//                .execute()
//                .value
//
//            authorImage = profileImage
            
            let username: String = try await baseQuery
                .select("username")
                .eq("id", value: userID)
                .single()
                .execute()
                .value
            
//            let displayName: String = try await baseQuery
//                .select("display_name")
//                .eq("id", value: userID)
//                .single()
//                .execute()
//                .value
            
            authorName = username
        } catch {
            print("ERROR FETCHING DETAILS: \(error)")
        }
    }
    
    
}

#Preview {
    PostCard(post: Petition.petition1())
}
