//
//  PlayerOverlay.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/13/25.
//

import SwiftUI

struct PlayerOverlay: View {
    
    @State private var isPaused = false
    @State private var showLike = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack (alignment: .bottom, spacing: 8){
                    VStack (alignment: .leading, spacing: 6){
                        HStack(alignment: .center, spacing: 4) {
                            Circle()
                                .frame(width: 12, height: 12)
                            Text("Author")
                                .fontStyle(.caption2)
                        }
                        Text("Title")
                            .fontStyle(.headline)
                        Text("Caption")
                            .fontStyle(.caption)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .bottomLeading)
                    VStack (spacing: 20) {
                        
                        VStack (spacing: 4) {
                            Image("demo.like.fill")
                                .symbolRenderingMode(.multicolor)
                                .foregroundStyle(.accent)
                            Text("90")
                                .fontStyle(.caption2)
                        }
                        
                        VStack (spacing: 4) {
                            Image("demo.dislike.fill")
                                .symbolRenderingMode(.multicolor)
                            Text("90")
                                .fontStyle(.caption2)
                        }
                        
                        VStack (spacing: 4) {
                            Image(systemName: "ellipsis.bubble.fill")
                            Text("90")
                                .fontStyle(.caption2)
                        }
                        
                        
                        VStack (spacing: 4) {
                            Image(systemName:"arrowshape.turn.up.forward.fill")
                            Text("10")
                                .fontStyle(.caption2)
                        }
                        
                        Image(systemName:"music.microphone.circle.fill")
                        
                    }
                    .font(.title)
                    .frame(maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(.trailing)
                    .padding(.bottom)
                }
                .foregroundStyle(.white)
                .background(.red.opacity(0.2))
                .shadow(radius: 6)
                .containerRelativeFrame(.vertical)
                .onTapGesture(count: 2) {
                    withAnimation(.smooth(duration: 0.15)) {
                        showLike = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.smooth(duration: 0.15)){
                                showLike = false
                            }
                        }
                    }
                }
                .onTapGesture { withAnimation(.smooth(duration: 0.15)) { isPaused.toggle() } }
                .overlay {
                    Image(systemName: "play.fill")
                        .font(.custom("Unbounded", fixedSize: 84))
                        .foregroundStyle(.thinMaterial)
                        .scaleEffect(isPaused ? 1 : 0.5)
                        .opacity(isPaused ? 1 : 0)
                        .environment(\.colorScheme, .light)
                    
                    Image("demo.like.fill")
                        .font(.custom("Unbounded", fixedSize: 84))
                        .symbolRenderingMode(.multicolor)
                        .foregroundStyle(.accent)
                        .symbolEffect(.bounce, value: showLike)
                        .scaleEffect(showLike ? 1 : 0.5)
                        .opacity(showLike ? 1 : 0)
                        
                }
            }
        }
    }
}

#Preview {
    PlayerOverlay()
}
