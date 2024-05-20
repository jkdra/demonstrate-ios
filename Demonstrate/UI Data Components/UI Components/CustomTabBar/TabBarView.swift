//
//  TabBarView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/13/24.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, search, newPost, activity, profile
    
    var iconName: String {
        switch self {
        case .home: "demo.home"
        case .search: "magnifyingglass"
        case .newPost: "plus"
        case .activity: "bell.fill"
        case .profile: "person.crop.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .newPost: "Post"
        case .activity: "Activity"
        case .profile: "Profile"
        }
    }
}

struct TabBarView: View {
    
    @Namespace var namespace
    @State private var newPost = false
    
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @State var localSelection: TabBarItem
    
    var body: some View {
        ZStack (alignment: .bottom) {
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    tabView(tab: tab)
                        .onChange(of: selection) {
                            withAnimation(.snappy(duration: 0.3, extraBounce: 0.05)) {
                                if tab != .newPost { localSelection = selection }
                            }
                        }
                        .onTapGesture { if tab != .newPost { selection = tab } }
                }
            }
            .padding(.vertical, 2)
        }
    }
}

extension TabBarView {
    
    private func tabView(tab: TabBarItem) -> some View {
        VStack (spacing: 4) {
            if tab.title != "Post" {
                if localSelection == tab {
                    Capsule()
                        .frame(width: 20, height: 2)
                        .shadow(color: .accentColor.opacity(0.7), radius: 2)
                        .matchedGeometryEffect(id: "SelectedTab", in: namespace)
                } else {
                    Capsule()
                        .foregroundStyle(.clear)
                        .frame(width: 16, height: 2)
                    
                }
                Group { tab.title != "Home" ? Image(systemName: tab.iconName) : Image(tab.iconName) }
                    .font(.title2)
                
                Text(tab.title)
                    .font(.custom("Unbounded", size: 9))
                
            } else {
                Button { newPost = true }
                label: {
                    Image(systemName: tab.iconName)
                        .foregroundStyle(.tint)
                        .bold()
                }
                .padding(10)
                .background(
                    LinearGradient(
                        colors: [.white.opacity(0.2), .black.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom),
                    in: .circle.stroke(lineWidth: 6)
                )
                .background(.regularMaterial, in: .circle)
                .clipShape(.circle)
                
                
            }
        }
        .foregroundStyle(localSelection == tab ? Color.accentColor : .secondary)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $newPost) { PostTypeView(isPresented: $newPost) }
    }
}

struct TabBar_Preview: PreviewProvider {
    
    static let tabs: [TabBarItem] = [ .home, .search, .newPost, .activity, .profile ]
    
    static var previews: some View {
        VStack {
            TabBarView(tabs: tabs, selection: .constant(.home), localSelection: .home)
        }
    }
}
