//
//  TextFieldPreview.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI

struct TextFieldPreview: View {
    
    @State private var testText: String = ""
    @State private var testText2: String = ""
    
    var body: some View {
        HStack {
            TextInput("Test", text: $testText)
                .textInputAutocapitalization(.never)
            
            TextInput("Test", text: $testText2)
                .textInputAutocapitalization(.never)
        }
        .safeAreaPadding()
    }
}

#Preview {
    TextFieldPreview()
}
