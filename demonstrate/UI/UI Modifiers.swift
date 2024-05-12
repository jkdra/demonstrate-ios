//
//  UI Modifiers.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import SwiftUI

struct SpecialNavBar: ViewModifier {

    init() {
        let navigationBarAppearance = UINavigationBarAppearance()
        
        // Safely load the custom fonts with fallbacks
        let largeTitleFont = UIFont(name: "Unbounded-Regular_Bold", size: 28) ?? UIFont.systemFont(ofSize: 28, weight: .bold)
        let titleFont = UIFont(name: "Unbounded-Regular_Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        
        // Set attributes for large titles and regular titles
        navigationBarAppearance.largeTitleTextAttributes = [.font: largeTitleFont]
        navigationBarAppearance.titleTextAttributes = [.font: titleFont]
        
        // Apply the appearance to standard and compact navigation bars
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        
        
        if let customFont = UIFont(name: "Unbounded", size: 16.0) {
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: customFont], for: .normal)
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

extension View {
    
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1.0)
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
}

extension View {

    func customNavBar(_ title: String) -> some View {
        self
            .modifier(SpecialNavBar())
            .navigationTitle(title)
    }
}

struct StetchyHeaderViewModifier: ViewModifier {
    
    var startingHeight: CGFloat = 300
    var coordinateSpace: CoordinateSpace = .global
    
    func body(content: Content) -> some View {
        GeometryReader(content: { geometry in
            content
                .frame(width: geometry.size.width, height: stretchedHeight(geometry))
                .clipped()
                .offset(y: stretchedOffset(geometry))
        })
        .frame(height: startingHeight)
    }
    
    private func yOffset(_ geo: GeometryProxy) -> CGFloat {
        geo.frame(in: coordinateSpace).minY
    }
    
    private func stretchedHeight(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? (startingHeight + offset) : startingHeight
    }
    
    private func stretchedOffset(_ geo: GeometryProxy) -> CGFloat {
        let offset = yOffset(geo)
        return offset > 0 ? -offset : 0
    }
}

public extension View {
    
    func asStretchyHeader(startingHeight: CGFloat) -> some View {
        modifier(StetchyHeaderViewModifier(startingHeight: startingHeight))
    }
}


/// Adds a transparent View and read it's frame.
///
/// Adds a GeometryReader with infinity frame.
public struct FrameReader: View {
    
    let coordinateSpace: CoordinateSpace
    let onChange: (_ frame: CGRect) -> Void
    
    public init(coordinateSpace: CoordinateSpace, onChange: @escaping (_ frame: CGRect) -> Void) {
        self.coordinateSpace = coordinateSpace
        self.onChange = onChange
    }

    public var body: some View {
        GeometryReader { geo in
            Text("")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear(perform: {
                    onChange(geo.frame(in: coordinateSpace))
                })
                .onChange(of: geo.frame(in: coordinateSpace)) { onChange(geo.frame(in: coordinateSpace)) }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

public extension View {
    
    /// Get the frame of the View
    ///
    /// Adds a GeometryReader to the background of a View.
    func readingFrame(coordinateSpace: CoordinateSpace = .global, onChange: @escaping (_ frame: CGRect) -> ()) -> some View {
        background(FrameReader(coordinateSpace: coordinateSpace, onChange: onChange))
    }
}
