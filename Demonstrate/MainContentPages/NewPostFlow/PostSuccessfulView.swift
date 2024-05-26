//
//  PostSuccessfulView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct PostSuccessfulView: View {
    
    @Binding var isPresented: Bool
    @State var postType: PostType
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading, spacing: 10){
                ProgressView(value: 1)
                Text("You have successfully published \(postType == .event ? "an" : "a") \(postType.postTitle.lowercased())!")
                    .headline()
                    .hAlign(.leading)
                
                Spacer()
                
                Button("Close") { isPresented = false }
                    .primaryButton()
            }
            .customNavBar("\(postType.postTitle) Posted!")
            .navigationBarBackButtonHidden()
            .navigationPopGestureDisabled()
            .safeAreaPadding(.horizontal)
            .safeAreaPadding(.bottom)
        }
    }
}

#Preview {
    PostSuccessfulView(isPresented: .constant(true), postType: .event)
}
