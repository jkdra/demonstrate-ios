//
//  RadialMenu.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/16/25.
//

import SwiftUI

struct RadialMenu: View {
    @State private var isMenuVisible = true
    @State private var selectedOption: Int? = nil
    @GestureState private var touchLocation: CGPoint = .zero

    let menuOptions = ["Option 1", "Option 2", "Option 3", "Option 4", "Option 5"]
    let menuRadius: CGFloat = 100

    var body: some View {
        ZStack {
            // Background Overlay
            if isMenuVisible {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { dismissMenu() }
            }

            // Radial Menu
            if isMenuVisible {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: menuRadius * 2, height: menuRadius * 2)
                        .onTapGesture {
                            dismissMenu()
                        }

                    // Menu Items
                    ForEach(menuOptions.indices, id: \.self) { index in
                        let angle = angleForIndex(index)
                        let position = positionForAngle(angle)

                        Text(menuOptions[index])
                            .foregroundColor(selectedOption == index ? .blue : .black)
                            .position(position)
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .updating($touchLocation) { value, state, _ in
                            state = value.location
                        }
                        .onChanged { value in
                            handleDragChange(value)
                        }
                        .onEnded { _ in
                            confirmSelection()
                        }
                )
            }
        }
        .onLongPressGesture { isMenuVisible = true }
        .animation(.smooth(duration: 0.2), value: isMenuVisible)
    }

    // MARK: - Helper Methods

    func angleForIndex(_ index: Int) -> CGFloat {
        let anglePerOption = 2 * .pi / CGFloat(menuOptions.count)
        return anglePerOption * CGFloat(index) - .pi / 2
    }

    func positionForAngle(_ angle: CGFloat) -> CGPoint {
        let x = cos(angle) * menuRadius + menuRadius
        let y = sin(angle) * menuRadius + menuRadius
        return CGPoint(x: x, y: y)
    }

    func handleDragChange(_ value: DragGesture.Value) {
        let location = value.location
        let center = CGPoint(x: menuRadius, y: menuRadius)

        let dx = location.x - center.x
        let dy = location.y - center.y

        let distance = sqrt(dx * dx + dy * dy)
        let angle = atan2(dy, dx) + .pi / 2

        if distance > menuRadius {
            selectedOption = nil // Outside menu
        } else {
            let adjustedAngle = (angle < 0) ? angle + 2 * .pi : angle
            selectedOption = Int(adjustedAngle / (2 * .pi) * CGFloat(menuOptions.count)) % menuOptions.count
        }
    }

    func confirmSelection() {
        if let selectedOption = selectedOption {
            print("Selected: \(menuOptions[selectedOption])")
        }
        dismissMenu()
    }

    func dismissMenu() {
        isMenuVisible = false
        selectedOption = nil
    }
}

#Preview {
    RadialMenu()
}
