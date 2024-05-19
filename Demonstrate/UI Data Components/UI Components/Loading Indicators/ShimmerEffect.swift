//
//  ShimmerEffect.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct ShimmerEffect: View {
    
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    
    var body: some View {
        LinearGradient(
            colors: [
                Color(uiColor: .systemGray5),
                Color(uiColor: .systemGray6),
                Color(uiColor: .systemGray5)
            ],
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false)) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2.2, y: 2.2)
            }
        }
    }
}

#Preview {
    ShimmerEffect()
}
