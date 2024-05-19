//
//  TextFieldStyles.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/16/24.
//

import Foundation
import SwiftUI


extension View {
    
    func plainTextField() -> some View { self.modifier(CustomTextFieldStyle()) }
    
    // These apply to post creation and editing
    func titleField() -> some View { self.modifier(TitleFieldStyle()) }
    
    func summaryField() -> some View { self.modifier(SummaryFieldStyle()) }
    
    func descriptionField() -> some View { self.modifier(DescriptionFieldStyle()) }
    
    // These apply user accounts and profiles
    func usernameField() -> some View { self.modifier(UsernameFieldStyle()) }
    
    func displayNameField() -> some View { self.modifier(DisplayNameFieldStyle()) }
    
    func bioField() -> some View { self.modifier(BiographyFieldStyle()) }
    
}

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

struct PostFields: View {
    var body: some View {
        TextField("Title", text: .constant(""))
    }
}


struct TitleFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textInputAutocapitalization(.words)
            .modifier(CustomTextFieldStyle())
            .bold()
    }
}

struct SummaryFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 48, alignment: .top)
            .textInputAutocapitalization(.sentences)
            .modifier(CustomTextFieldStyle())
    }
}

struct DescriptionFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 164, alignment: .top)
            .textInputAutocapitalization(.sentences)
            .modifier(CustomTextFieldStyle())
    }
}

struct UsernameFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textCase(.lowercase)
            .textContentType(.username)
            .textInputAutocapitalization(.never)
            .modifier(CustomTextFieldStyle())
    }
}
struct DisplayNameFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textContentType(.name)
            .textInputAutocapitalization(.words)
            .modifier(CustomTextFieldStyle())
    }
}

struct BiographyFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 48, alignment: .top)
            .textInputAutocapitalization(.sentences)
            .modifier(CustomTextFieldStyle())
    }
}


