//
//  TintWave.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 1/19/25.
//

import SwiftUI

struct TintWave: View {
    
    private var timeCurve: Animation = .timingCurve(0.25, 0.7, 1, 1, duration: 0.7)
    private var colors: [Color] = [.accent.opacity(0), .accent.opacity(0.5), .accent.opacity(0)]
    @State var startPoint: CGFloat = -300
    @State var endPoint: CGFloat = -0.01
    @Binding var trigger: Bool
    
    public init(trigger: Binding<Bool>) {
        self._trigger = trigger
    }
    
    var body: some View {
        RadialGradient(colors: colors, center: .init(x: 0.5, y: -0.1), startRadius: startPoint, endRadius: endPoint)
            .ignoresSafeArea()
        .containerRelativeFrame([.horizontal, .vertical])
        .safeAreaPadding()
        .onChange(of: trigger) {
            if trigger {
                withAnimation(timeCurve) {
                    startPoint = 1000
                    endPoint = 1300
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    startPoint = -300
                    endPoint = -0.01
                    trigger = false
                }
            }
        }
        .mask {
            Image("WaveOverlay")
                .resizable()
                .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
        }
        .allowsHitTesting(false)
    }
}

#Preview {
    
    @Previewable @State var trigger = false
    
    VStack {
        TintWave(trigger: $trigger)
        Button("Test") {
            trigger.toggle()
        }
    }
}
