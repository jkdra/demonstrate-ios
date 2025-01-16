//
//  TextFieldStyle.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI

enum TextFieldLocation {
    case top
    case center
    case bottom
    case singular
    
}

extension Shape {
    public func eraseToAnyShape() -> AnyShape { AnyShape(self) }
}

struct TextInput: View {
    var title: String
    var color: Color
    var location: TextFieldLocation
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>, color: Color = .secondary, location: TextFieldLocation = .singular) {
        self.title = title
        self._text = text
        self.color = color
        self.location = location
    }
    
    var body: some View {
        
        var topCornerRadius: CGFloat { location == .top ? 12 : 0 }
        var bottomCornerRadius: CGFloat { location == .bottom ? 12 : 0 }
        
        TextField(title, text: $text)
            .padding(12)
            .background(color != .secondary ? color.opacity(0.15) : Color(uiColor: .secondarySystemBackground))
            .overlay {
                if location == .singular {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 5)
                        .fill(color != .secondary ? color : Color(uiColor: .tertiarySystemBackground))
                } else {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: topCornerRadius,
                                                              bottomLeading: bottomCornerRadius,
                                                              bottomTrailing: bottomCornerRadius,
                                                              topTrailing: topCornerRadius))
                    .stroke(lineWidth: 5)
                    .fill(color != .secondary ? color : Color(uiColor: .tertiarySystemBackground))
                }
            }
            .clipShape(
                location == .singular
                ? RoundedRectangle(cornerRadius: 12).eraseToAnyShape()
                : UnevenRoundedRectangle(cornerRadii: .init(topLeading: topCornerRadius,
                                           bottomLeading: bottomCornerRadius,
                                           bottomTrailing: bottomCornerRadius,
                                           topTrailing: topCornerRadius)
                ).eraseToAnyShape()
            )
            .fontStyle(.body)
    }
}


struct SecureInput: View {
    var title: String
    var color: Color
    var location: TextFieldLocation
    @Binding var text: String
    
    init(_ title: String, text: Binding<String>, color: Color = .secondary, location: TextFieldLocation = .singular) {
        self.title = title
        self._text = text
        self.color = color
        self.location = location
    }
    
    var body: some View {
        
        var topCornerRadius: CGFloat { location == .top ? 12 : 0 }
        var bottomCornerRadius: CGFloat { location == .bottom ? 12 : 0 }
        
        SecureField(title, text: $text)
            .padding(12)
            .background(color != .secondary ? color.opacity(0.15) : Color(uiColor: .secondarySystemBackground))
            .overlay {
                if location == .singular {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 5)
                        .fill(color != .secondary ? color : Color(uiColor: .tertiarySystemBackground))
                } else {
                    UnevenRoundedRectangle(cornerRadii: .init(topLeading: topCornerRadius,
                                                              bottomLeading: bottomCornerRadius,
                                                              bottomTrailing: bottomCornerRadius,
                                                              topTrailing: topCornerRadius))
                    .stroke(lineWidth: 5)
                    .fill(color != .secondary ? color : Color(uiColor: .tertiarySystemBackground))
                }
            }
            .clipShape(
                location == .singular
                ? RoundedRectangle(cornerRadius: 12).eraseToAnyShape()
                : UnevenRoundedRectangle(cornerRadii: .init(topLeading: topCornerRadius,
                                           bottomLeading: bottomCornerRadius,
                                           bottomTrailing: bottomCornerRadius,
                                           topTrailing: topCornerRadius)
                ).eraseToAnyShape()
            )
            .fontStyle(.body)
    }
}
