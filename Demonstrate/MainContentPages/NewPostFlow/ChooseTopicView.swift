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
    var fromShortcut: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var topicChoice: Topic?
    @State private var proceed = false
    
    var body: some View {
        NavigationStack {
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
            .navigationDestination(isPresented: $proceed) { ImpressionView() }
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .safeAreaPadding(.bottom, 84)
            .toolbar {
                if fromShortcut {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                        .font(.custom("Unbounded", size: 14))
                    }
                }
                
            }
            .overlay(alignment: .bottom) {
                Button("Continue") {
                    AppSettingsManager().primaryButtonHaptic()
                    proceed = true
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
            .interactiveDismissDisabled()
        }
    }
}

#Preview { ChooseTopicView(postType: .petition, fromShortcut: true) }
