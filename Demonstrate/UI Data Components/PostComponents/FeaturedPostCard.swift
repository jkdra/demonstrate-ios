//
//  FeaturedPostCard.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import NukeUI

struct FeaturedPostCard: View {
    
    var viewModel = PostCardViewModel()
    
    let imageURL = "earhlb"
    
    var body: some View {
        
        LazyImage(url: URL(string: imageURL)) { state in
            if let image = state.image {
                image.resizable()
            } else {
                Color(uiColor: .secondarySystemBackground)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 128))
                            .padding(.trailing, -24)
                            .foregroundStyle(LinearGradient(colors: [.accentColor, .accentColor.opacity(0.3)], startPoint: .top, endPoint: .bottom))
                    }
            }
        }
        .aspectRatio(contentMode: .fill)
        .containerRelativeFrame(.horizontal)
        .frame(height: 316)
        .overlay(alignment: .bottomLeading) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .modifier(CustomTitlePostCard())
                Text("Summary\nSummary")
                    .modifier(CustomBodyPostCard())
            }
            .padding()
            .padding(.top)
            .foregroundStyle(.primary)
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
                    Button("View Author") {
                        
                    }
                    
                    Button("Report Post", role: .destructive) {
                        
                    }
                } label: {
                    Image(systemName: "ellipsis")
                    
                }
                .foregroundStyle(.primary)
            }
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
            Button("View Author") { }
            
            Button("Report Post", role: .destructive) { }
        }
    }
}

#Preview {
    FeaturedPostCard()
}
