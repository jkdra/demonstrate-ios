//
//  ImpressionView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/14/24.
//

import SwiftUI
import PhotosUI

struct ImpressionView: View {
    
    @State var title = ""
    @State var summary = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var imgData: Data?
    @FocusState var focus: Bool
    
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 10) {
                ProgressView(value: 0.4)
                Text("People do, in fact, judge books by their cover, so respond accordingly.")
                    .headline()
                
                PhotosPicker(selection: $photoItem, matching: .images) {
                    if let imgData, let uiimage = UIImage(data: imgData) {
                        Image(uiImage: uiimage)
                            .resizable()
                    } else {
                        RoundedRectangle(cornerRadius: 14)
                            .foregroundStyle(.tertiary)
                            .overlay {
                                VStack(spacing: 10) {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.largeTitle)
                                    
                                    Text("Tap to add an image")
                                        .font(.custom("Unbounded", size: 12))
                                    
                                    Text("(Optional, but **highly recommended**)")
                                        .footnotePage()
                                        .padding(.top, -12)
                                }
                            }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.91, height: 256)
                .clipShape(.rect(cornerRadius: 14))
                .onChange(of: photoItem) {
                    if let photoItem { updateImage(from: photoItem) }
                }
                
                TextField("Title", text: $title)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
                    .bold()
                
                TextField("Summary", text: $summary, axis: .vertical)
                    .frame(height: 48, alignment: .top)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
        }
        }
        .contentMargins(.horizontal, 16, for: .scrollContent)
        .customNavBar("Set an Impression")
        .overlay(alignment: .bottom) {
            if focus {
                Button("Done") { focus = false }
                    .font(.custom("Unbounded", size: 14))
                    .padding()
                    .hAlign(.leading)
                    .background(.regularMaterial)
            } else {
                Button("Continue") {
                    
                }
                .primaryButton()
                .disableWithOpacity(title.isEmpty || summary.isEmpty)
                .padding()
                .background {
                    Rectangle()
                        .foregroundStyle(.regularMaterial)
                        .mask {
                            LinearGradient(colors: [.white, .clear], startPoint: .center, endPoint: .top)
                        }
                        .ignoresSafeArea()
                }
            }
        }
    }
    
    func updateImage(from photoItem: PhotosPickerItem) {
        ProfileManagement().updateImage(from: photoItem) { data in
            imgData = data
        }
    }
}

#Preview {
    ImpressionView()
}
