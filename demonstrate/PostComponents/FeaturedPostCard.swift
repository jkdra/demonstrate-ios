//
//  FeaturedPostCard.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI

struct FeaturedPostCard: View {
    var body: some View {
        ZStack (alignment: .bottomLeading) {
            
            Image("NoPFP")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .containerRelativeFrame(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Title")
                    .modifier(CustomTitlePostCard())
                Text("Summary\nSummary")
                    .modifier(CustomBodyPostCard())
            }
            .shadow(radius: 4)
            .padding()
            .padding(.top)
            .foregroundStyle(.white)
            .hAlign(.leading)
            .background(LinearGradient(colors: [.black.opacity(0.8), .clear], startPoint: .bottom, endPoint: .top))
            
//            HStack(spacing: 10) {
//                
//                Text("Footer")
//                    .bold()
//                    .modifier(CustomFooterPostCard())
//                    .padding(.leading, 6)
//                Spacer()
//                
//                Menu {
//                    Button("View Author") {
//                        
//                    }
//                    
//                    Button("Report Post", role: .destructive) {
//                        
//                    }
//                } label: {
//                    Image(systemName: "ellipsis")
//                        .padding(.trailing, 6)
//                }
//                .foregroundStyle(.primary)
//
//            }
//            .padding(8)
//            .background(.regularMaterial, in: .capsule)
//            .vAlign(.top)
//            .padding(10)
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
            .padding(10)
            .padding(.horizontal, 6)
            .background(.regularMaterial, in: .rect(cornerRadius: 12))
            .padding(10)
            .padding(.horizontal, -2)
        }
    }
}

#Preview {
    FeaturedPostCard()
}
