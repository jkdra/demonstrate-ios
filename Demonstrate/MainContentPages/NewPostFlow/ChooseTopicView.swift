//
//  ChooseTopicView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/13/24.
//

import SwiftUI

struct ChooseTopicView: View {
    
    let postType: PostType
    private let columns = [GridItem(), GridItem()]
    private let topics = Topic.allTopics()
    @State private var topicChoice: Topic?
    
    var body: some View {
        ScrollView {
            ProgressView(value: 0.2)
            Text("Choose a topic which fits your post best.")
                .hAlign(.leading)
                .headline()
            
            LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                ForEach(topics, id: \.rawValue) { topic in
                    Button {
                        withAnimation(.snappy(duration: 0.2)) {
                            topicChoice = topic
                        }
                    } label: {
                        if topicChoice == topic {
                            TopicGridItemAlt(topic: topic)
                                .overlay(alignment: .topTrailing) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .padding(6)
                                        .font(.title2)
                                        .foregroundStyle(topic.colorHex)
                                }
                        } else {
                            TopicGridItem(topic: topic)
                        }
                    }
                }
            }
        }
        .contentMargins(.horizontal, 16, for: .scrollContent)
        .safeAreaPadding(.bottom, 84)
        .overlay(alignment: .bottom) {
            NavigationLink("Continue") {
                ImpressionView()
            }
            .primaryButton()
            .padding()
            .disableWithOpacity(topicChoice == nil)
            .background {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
                    .mask {
                        LinearGradient(colors: [.white, .clear], startPoint: .center, endPoint: .top)
                    }
                    .ignoresSafeArea()
            }
        }
        .customNavBar("Choose Topic")
    }
}

#Preview { ChooseTopicView(postType: .petition) }
