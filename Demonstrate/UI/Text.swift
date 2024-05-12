//
//  Text.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import SwiftUI

struct CustomTextFieldStyle: ViewModifier {
    
    var bgColor: Color = Color(uiColor: .secondarySystemBackground)
    
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.custom("Unbounded", size: 14))
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .foregroundStyle(bgColor.opacity(bgColor == Color(uiColor: .secondarySystemBackground) ? 1 : 0.2))
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 4)
                    .foregroundStyle(bgColor == Color(uiColor: .secondarySystemBackground) ? .tertiary : .primary)
            }
            .clipShape(.rect(cornerRadius: 14))
    }
}

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
