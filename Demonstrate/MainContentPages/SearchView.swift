//
//  SearchView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/13/24.
//

import SwiftUI

struct SearchView: View {
    
    @Bindable var viewModel = SearchViewModel()
    
    let topics: [Topic] = Topic.allTopics()
    private let columns = [GridItem(), GridItem()]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Section {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                        ForEach(topics, id: \.rawValue) { topic in
                            NavigationLink {
                                TopicView(topic: topic)
                            } label: { TopicGridItem(topic: topic) }
                        }
                    }
                } header: {
                    Text("Browse Topics")
                        .sectionHeader()
                }
            }
            .contentMargins(16, for: .scrollContent)
            .customNavBar("Search")
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search Users, Petitions, or Events."))
            .font(.custom("Unbounded", size: 14))
        }
    }
}

@Observable
class SearchViewModel {
    var searchText = ""
    
    
}

struct TopicGridItem: View {
    
    let topic: Topic
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(topic.colorHex)
            .frame(height: 128)
            .overlay(alignment: .topTrailing) {
                Image(systemName: topic.systemImage)
                    .foregroundStyle(LinearGradient(colors: [.white.opacity(0.8), .white.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                    .font(.system(size: 64))
                    .padding(.top, 18)
                    .padding(.trailing, -12)
            }
            .overlay(alignment: .bottomLeading) {
                Text(topic.title)
                    .padding(12)
                    .font(.custom("Unbounded-Regular_Bold", size: 14))
                    .foregroundStyle(.white)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.25)], startPoint: .top, endPoint: .bottom))
            }
            .clipShape(.rect(cornerRadius: 14))
    }
}

struct TopicGridItemAlt: View {
    
    let topic: Topic
    @Environment(\.colorScheme) private var scheme
    
    var foregroundSwitch: Color {
        if scheme == .dark {
            if topic == .film { return .gray }
            else if topic == .publicSafety { return .blue }
            else if topic == .mentalHealth { return .purple.opacity(0.8) }
            else { return topic.colorHex }
        } else { return topic.colorHex }
    }
    
    var body: some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(topic.colorHex.opacity(0.25))
            .frame(height: 128)
            .overlay(alignment: .topTrailing) {
                Image(systemName: topic.systemImage)
                    .foregroundStyle(LinearGradient(colors: [foregroundSwitch.opacity(0.8), topic.colorHex.opacity(0.2)], startPoint: .top, endPoint: .bottom))
                    .font(.system(size: 64))
                    .padding(.top, 18)
                    .padding(.trailing, -12)
            }
            .overlay(alignment: .bottomLeading) {
                Text(topic.title)
                    .padding(12)
                    .font(.custom("Unbounded-Regular_Bold", size: 14))
                    .foregroundStyle(foregroundSwitch)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 14)
                    .stroke(lineWidth: 6)
                    .foregroundStyle(LinearGradient(colors: [.white.opacity(0.2), .black.opacity(0.1)], startPoint: .top, endPoint: .bottom))
            }
            .clipShape(.rect(cornerRadius: 14))
    }
}



#Preview {
    SearchView()
}
