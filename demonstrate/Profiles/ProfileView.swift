//
//  ProfileView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import SwiftUI
import UIKit

struct ProfileView: View {
    
    @Environment(\.dynamicTypeSize) var typeSize
    
    var body: some View {
        
        var buttonLayout: AnyLayout {
            !typeSize.isAccessibilitySize ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout(alignment: .leading, spacing: 12))
        }
        
        var infoLayout: AnyLayout {
            !typeSize.isAccessibilitySize ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        }
        
        var thirdLayout: AnyLayout {
            !typeSize.isAccessibilitySize ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
        }
        
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack (alignment: .center, spacing: 12){
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(.accent)
                            .overlay {
                                Image("demo.fill")
                                    .foregroundStyle(Color(uiColor: .systemBackground))
                                    .font(.custom("Unbounded", fixedSize: 36))
                            }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Display Name")
                                .fontStyle(.headline)
                            
                            Text("Username")
                                .fontStyle(.subheadline)
                                .opacity(0.6)
                        }
                    }
                    .hAlign(.leading)
                    
                    buttonLayout {
                        
                        thirdLayout {
                            Text("100")
                                .bold()
                            
                            Text("Followers")
                                .fontStyle(.caption)
                        }
                        .hAlign(typeSize.isAccessibilitySize ? .leading : .center)
                        
                        if !typeSize.isAccessibilitySize {
                            Divider()
                                .frame(height: 24)
                        }
                        
                        
                        thirdLayout {
                            Text("100")
                                .bold()
                            
                            Text("Following")
                                .fontStyle(.caption)
                        }
                        .hAlign(typeSize.isAccessibilitySize ? .leading : .center)
                        
                        if !typeSize.isAccessibilitySize {
                            Divider()
                                .frame(height: 24)
                        }
                        
                        thirdLayout {
                            Text("-10")
                                .bold()
                            
                            Text("L/D Count")
                                .fontStyle(.caption)
                        }
                        .hAlign(typeSize.isAccessibilitySize ? .leading : .center)
                    }
                    .multilineTextAlignment(.center)
                    .fontStyle(.callout)
                    .lineSpacing(2)
                    
                    buttonLayout {
                        Button("Follow") {
                            
                        }
                        .primaryButton()
                        
                        Button("Message") {
                            
                        }
                        .secondaryButton()
                    }
                    
                    Text("Hello\nHello")
                        .multilineTextAlignment(.leading)
                        .fontStyle(.callout)
                        .lineSpacing(2)
                        .lineLimit(3)
                    
                    Divider()
                }
                .safeAreaPadding()
            }
            .toolbarTitleDisplayMode(.inline)
            .customNavBar("username")
            .toolbarTitleMenu {
                Button("More Info", systemImage: "info.circle.fill") {
                    
                }
                Button("Switch Profile", systemImage: "person.fill") {
                    
                }
                Button("Report", systemImage: "exclamationmark.triangle.fill", role: .destructive) {
                    
                }
            }
            .refreshable {
                
            }
        }
    }
}

#Preview {
    ProfileView()
}
