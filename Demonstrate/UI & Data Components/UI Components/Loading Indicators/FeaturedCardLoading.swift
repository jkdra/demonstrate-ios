//
//  FeaturedPostCardLoading.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct FeaturedCardLoading: View {
    var body: some View {
        ShimmerEffect()
            .frame(height: 284)
            .clipShape(.rect(cornerRadius: 14))
            .containerRelativeFrame(.horizontal)
            .scrollTransition { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.5)
                    .scaleEffect(phase.isIdentity ? 1 : 0.98)
            }
    }
}

#Preview {
    FeaturedCardLoading()
}
