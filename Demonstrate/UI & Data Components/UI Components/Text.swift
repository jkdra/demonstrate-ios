//
//  Text.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import SwiftUI



extension View {
    func largeTitle() -> some View {
        self.modifier(CustomLargeTitle())
    }
    
    func headline() -> some View {
        self.modifier(CustomHeadline())
    }
    
    func footnotePage() -> some View {
        self.modifier(FootnotePage())
    }
    
    func titleCard() -> some View {
        self.modifier(CustomTitlePostCard())
    }
    
    func bodyCard() -> some View {
        self.modifier(CustomBodyPostCard())
    }
    
    func sectionHeader() -> some View {
        self.modifier(SectionHeaderStyle())
    }
}

struct SectionHeaderStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular_Bold", size: 20))
            .hAlign(.leading)
    }
}

struct FootnotePage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular", size: 12))
            .foregroundStyle(.secondary)
            .lineSpacing(2)
            .multilineTextAlignment(.center)
            .padding(.top, 6)
    }
}

struct CustomLargeTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular_Bold", size: 28))
            .foregroundStyle(.accent)
        
    }
}

struct CustomHeadline: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded", size: 16))
            .lineSpacing(2)
    }
}

struct CustomTitlePostCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular_Bold", size: 16))
            .lineLimit(1)
    }
}

struct CustomBodyPostCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular", size: 14))
            .foregroundStyle(.secondary)
            .lineSpacing(4)
    }
}

struct CustomFooterPostCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular", size: 12))
            .foregroundStyle(.tertiary)
    }
}
