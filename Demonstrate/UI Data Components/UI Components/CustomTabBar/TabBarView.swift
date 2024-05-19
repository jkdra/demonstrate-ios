//
//  TabBarView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/13/24.
//

import Foundation
import SwiftUI

enum TabBarItem: Hashable {
    case home, search, newpost, activity, profile
    
    var iconName: String {
        switch self {
        case .home:
            return "demo.home"
        case .search:
            return "magnifyingglass"
        case .newpost:
            return "plus"
        case .activity:
            return "bell.fill"
        case .profile:
            return "person.crop.circle.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .newpost:
            return "Post"
        case .activity:
            return "Activity"
        case .profile:
            return "Profile"
        }
    }
}

struct TabBarView: View {
    
    @Namespace var namespace
    @State private var newPost: Bool = false
    
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
                                if tab != .newpost { localSelection = selection }
                            }
                        }
                        .onTapGesture { if tab != .newpost { switchTab(tab: tab) } }
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
                        .frame(width: 20, height: 3)
                        .shadow(color: .accentColor.opacity(0.5), radius: 2)
                        .matchedGeometryEffect(id: "SelectedTab", in: namespace)
                } else {
                    Capsule()
                        .foregroundStyle(.clear)
                        .frame(width: 16, height: 3)
                    
                }
                if tab.title != "Home" {
                    Image(systemName: tab.iconName)
                        .font(.title3)
                } else {
                    Image(tab.iconName)
                        .font(.title3)
                }
                Text(tab.title)
                    .font(.custom("Unbounded", size: 10))
                
            } else {
                Button {
                    newPost = true
                } label: {
                    Image(systemName: tab.iconName)
                        .foregroundStyle(.tint)
                        .bold()
                }
                .padding(10)
                .background(
                    LinearGradient(
                        colors: [.white.opacity(0.2), .black.opacity(0.2)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    in: .circle
                        .stroke(lineWidth: 3)
                )
                .background(.regularMaterial, in: .circle)
                
                
            }
        }
        .foregroundStyle(localSelection == tab ? Color.accentColor : .secondary)
        .frame(maxWidth: .infinity)
        .sheet(isPresented: $newPost) { PostTypeView(isPresented: $newPost) }
    }
    
    private func switchTab(tab: TabBarItem) { selection = tab }
}

struct TabBar_Preview: PreviewProvider {
    
    static let tabs: [TabBarItem] = [
        .home, .search, .newpost, .activity, .profile
    ]
    
    static var previews: some View {
        VStack {
            TabBarView(tabs: tabs, selection: .constant(.home), localSelection: .home)
        }
    }
}
