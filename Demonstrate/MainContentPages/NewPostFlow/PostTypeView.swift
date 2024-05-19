//
//  PostTypeView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import SwiftUI

struct PostTypeView: View {
    
    @Binding var isPresented: Bool
    @State var postTypeSelection: PostType?
    
    let postTypeOptions: [PostType] = [.petition, .event]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 10){
                
                ForEach(postTypeOptions, id: \.rawValue) { postType in
                    postType.postLabel
                        .background(postTypeSelection == postType ? .accentColor : Color(uiColor: .secondarySystemBackground), in: .rect(cornerRadius: 14))
                        .overlay(alignment: .topTrailing) {
                            Image(systemName: postTypeSelection == postType ? "checkmark.circle.fill" : "circle")
                                .bold(postTypeSelection == postType)
                                .padding(10)
                                .opacity(postTypeSelection == postType ? 1 : 0.3)
                                .font(.title3)
                        }
                        .foregroundStyle(postTypeSelection == postType ? Color(uiColor: .systemBackground) : .primary)
                        .onTapGesture {
                            withAnimation(.snappy(duration: 0.2)) {
                                postTypeSelection = postType
                            }
                        }
                        .disableWithOpacity(postType == .event)
                }
                NavigationLink("Continue") {
                    if let postTypeSelection { ChooseTopicView(postType: postTypeSelection) }
                    
                }
                .primaryButton()
                .disableWithOpacity(postTypeSelection == nil)
            }
            .padding()
            .interactiveDismissDisabled()
            .customNavBar("New Post")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isPresented = false }
                        .font(.custom("Unbounded", size: 14))
                }
            }
        }
    }
}

#Preview {
    PostTypeView(isPresented: .constant(true))
}
