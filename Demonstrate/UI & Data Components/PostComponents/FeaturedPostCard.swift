//
//  FeaturedPostCard.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import NukeUI

struct FeaturedPostCard: View {
    
    var viewModel = PostCardViewModel(post: Petition.petition1())
    
    let imageURL = ""
    
    var body: some View {
        let post = viewModel.post
        LazyImage(url: URL(string: imageURL)) { state in
            if let image = state.image {
                image.resizable()
            } else {
                Color(.accent)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 128))
                            .padding(.trailing, -24)
                            .foregroundStyle(LinearGradient(colors: [Color(uiColor: .systemBackground), Color(uiColor: .systemBackground).opacity(0.3)], startPoint: .top, endPoint: .bottom))
                    }
            }
        }
        .aspectRatio(contentMode: .fill)
        .containerRelativeFrame(.horizontal)
        .frame(height: 284)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(post.title)
                    .modifier(CustomTitlePostCard())
                Text(post.summary)
                    .lineLimit(2)
                    .modifier(CustomBodyPostCard())
            }
            .padding()
            .padding(.top)
            .foregroundStyle(Color(uiColor: .systemBackground))
            .hAlign(.leading)
            .background {
                if !imageURL.isEmpty { LinearGradient(colors: [.black.opacity(0.6), .clear], startPoint: .bottom, endPoint: .top) }
            }
        }
        .clipShape(.rect(cornerRadius: 14))
        .overlay(alignment: .top) {
            
            HStack {
                Text("Header")
                    .bold()
                    .modifier(CustomFooterPostCard())
                Spacer()
                
                Menu {
                    if let userID = post.userID { NavigationLink("View Author") { ProfileDetailView(profileID: userID) } }
                    
                    Button("Report Post", role: .destructive) {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                    
                }
                
            }
            .foregroundStyle(imageURL.isEmpty ? Color(uiColor: .systemBackground) : Color.primary)
            .padding(9)
            .background {
                if !imageURL.isEmpty {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.regularMaterial)
                }
            }
            .padding(6)
               
        }
        .clipShape(.rect(cornerRadius: 14))
        .contextMenu {
            if let userID = post.userID { NavigationLink("View Author") { ProfileDetailView(profileID: userID) } }
            
            Button("Report Post", role: .destructive) { }
        }
    }
}

#Preview {
    FeaturedPostCard()
}
