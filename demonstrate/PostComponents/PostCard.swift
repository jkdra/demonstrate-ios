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
            
        }
        VStack(alignment: .leading, spacing: 12) {
            Text("Title")
                .modifier(CustomTitlePostCard())
            
            Text("Summary\nSummary\nSummary")
                .modifier(CustomBodyPostCard())
            
            Text("Post Info")
                .bold()
                .modifier(CustomBodyPostCard())
            Divider()
            HStack {
                Circle()
                    .frame(width: 16, height: 16)
                Text("Footer")
                    .modifier(CustomFooterPostCard())
                
                Spacer()
                
                Text("Footer")
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
        .overlay(alignment: .topTrailing) {

            Menu {
                Button("View Author") {
                    
                }
                Button("Report Post", role: .destructive) {
                    
                }
            } label: {
                Image(systemName: "ellipsis")
                    .padding(8)
                    .background(.regularMaterial, in: .circle)
                    .padding(.trailing, -6)
                    .padding(10)
            }
            .foregroundStyle(.primary)
        }
        .clipShape(.rect(cornerRadius: 14))
        .contextMenu {
            Button("View Author") {
                
            }
            
            Button("Report Post", role: .destructive) {
                
            }
        }
    }
}

@Observable
class PostCardViewModel {
    
}

#Preview {
    PostCard()
}
