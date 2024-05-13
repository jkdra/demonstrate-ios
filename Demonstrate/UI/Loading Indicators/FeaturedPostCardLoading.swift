//
//  FeaturedPostCardLoading.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct FeaturedPostCardLoading: View {
    var body: some View {
        ShimmerEffect()
            .frame(height: 284)
            .clipShape(.rect(cornerRadius: 14))
    }
}

#Preview {
    FeaturedPostCardLoading()
}
