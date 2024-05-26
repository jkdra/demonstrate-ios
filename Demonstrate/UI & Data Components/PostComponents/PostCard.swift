//
//  PostCard.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct PostCard: View {
    var body: some View {
        NavigationLink {
            
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                Text("Title")
                    .modifier(CustomTitlePostCard())
                
                Text("Summary\nSummary\nSummary")
                    .lineLimit(3, reservesSpace: true)
                    .modifier(CustomBodyPostCard())
                
                Divider()
                HStack {
                    Circle()
                        .frame(width: 16, height: 16)
                    Text("Footer")
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
        .overlay(alignment: .topTrailing) {
            Menu {
                Button("View Author") {
                    
                }
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
            Button("View Author") {
                
            }
            Button("Report Post", role: .destructive) {
                
            }
        }
        .frame(maxWidth: 512)
    }
}

@Observable
class PostCardViewModel {
    
}

#Preview {
    PostCard()
}
