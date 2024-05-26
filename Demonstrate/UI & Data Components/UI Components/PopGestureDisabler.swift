//
//  PopGestureDisabler.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/15/24.
//

import Foundation
import SwiftUI

extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self) {
            $0.next
        }.first { $0 is UIViewController } as? UIViewController
    }
}

private struct NavigationPopGestureDisabler: UIViewRepresentable {
    let disabled: Bool
    func makeUIView(context: Context) -> some UIView { UIView() }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            uiView
                .parentViewController?
                .navigationController?
                .interactivePopGestureRecognizer?.isEnabled = !disabled
        }
    }
}

public extension View {
    @ViewBuilder
    func navigationPopGestureDisabled(_ disabled: Bool = true) -> some View { background { NavigationPopGestureDisabler(disabled: disabled) } }
}
