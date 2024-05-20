//
//  EditPostView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/16/24.
//

import SwiftUI
import NukeUI
import PhotosUI

struct EditPostView: View {
    
    @Bindable private var viewModel = PostManagementViewModel()
    @State var postToEdit: any Post = Petition.petition1()
    @State private var photoItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var signatureGoal = ""
    @State private var newStart: Date = Date()
    @State private var newEnd: Date = Date()
    @FocusState private var focus
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                PhotosPicker(selection: $photoItem, matching: .images) {
                    if let imageData, let uiiimg = UIImage(data: imageData) { Image(uiImage: uiiimg).resizable() } else {
                        LazyImage(url: URL(string: postToEdit.imageURL)) { state in
                            if let image = state.image { image.resizable() } else {
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundStyle(.tertiary)
                                    .overlay {
                                        VStack(spacing: 10) {
                                            Image(systemName: "photo.on.rectangle")
                                                .font(.largeTitle)
                                            
                                            Text("Tap to add an image")
                                                .font(.custom("Unbounded", size: 12))
                                        }
                                    }
                            }
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(height: 256)
                .clipShape(.rect(cornerRadius: 14))
                .onChange(of: photoItem) { if let photoItem { updateData(from: photoItem) } }
                
                if var event = postToEdit as? Event {
                    VStack (spacing: 0) {
                        DatePicker("From:", selection: $newStart)
                            .padding(10)
                            .padding(.leading, 6)
                            .background(Color(uiColor: .secondarySystemBackground), in: .rect(cornerRadii: .init(topLeading: 14, topTrailing: 14)))
                            .font(.custom("Unbounded", size: 14))
                        Divider()
                        DatePicker("To:", selection: $newEnd)
                            .padding(10)
                            .padding(.leading, 6)
                            .background(Color(uiColor: .secondarySystemBackground), in: .rect(cornerRadii: .init(bottomLeading: 14, bottomTrailing: 14)))
                            .font(.custom("Unbounded", size: 14))
                    }
                    .onAppear { newStart = event.startsAt; newEnd = event.endsAt }
                    .onChange(of: newStart) { event.startsAt = newStart; postToEdit = event }
                    .onChange(of: newEnd) { event.endsAt = newEnd; postToEdit = event }
                } else if postToEdit is Petition {
                    TextField("Signature Goal", text: $signatureGoal)
                        .modifier(CustomTextFieldStyle())
                }
                
                TextField("Title", text: $postToEdit.title)
                    .titleField()
                    .focused($focus)
                
                TextField("Summary", text: $postToEdit.summary, axis: .vertical)
                    .summaryField()
                    .focused($focus)
                
                TextField("Description", text: $postToEdit.description, axis: .vertical)
                    .descriptionField()
                    .focused($focus)
            }
            .safeAreaPadding(.bottom, 84)
            .contentMargins(.horizontal, 16, for: .scrollContent)
            .customNavBar("Edit \(postToEdit.postType.postTitle)")
            .overlay(alignment: .bottom) {
                if !focus {
                    Button("Save") { saveUpdates() }
                        .primaryButton()
                        .padding()
                        .background {
                            Rectangle()
                                .foregroundStyle(.regularMaterial)
                                .mask {
                                    LinearGradient(colors: [.white, .clear], startPoint: .center, endPoint: .top)
                                }
                                .ignoresSafeArea()
                        }
                } else {
                    Button("Done") { focus = false }
                        .font(.custom("Unbounded", size: 14))
                        .hAlign(.leading)
                        .padding()
                        .background(.regularMaterial)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.custom("Unbounded", size: 14))
                }
                
                ToolbarItem(placement: .primaryAction) { }
                
                ToolbarItem(placement: .secondaryAction) {
                    Picker("Change Topic", selection: $postToEdit.topic) {
                        ForEach(Topic.allTopics(), id: \.title) { Text($0.title).tag($0) }
                    }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Button("Archive \(postToEdit.postType.postTitle)") { archive() }
                }
                
                ToolbarItem(placement: .secondaryAction) {
                    Section {
                        Button("Delete \(postToEdit.postType.postTitle)", role: .destructive) { delete() }
                    }
                }
            }
        }
        .overlay { FullscreenLoading(show: $viewModel.loading) }
        .alert("Oh! uhm...", isPresented: $viewModel.error) { } message: { Text(viewModel.errMsg) }
    }
    
    func saveUpdates() {
        Task {
            let success = await viewModel.updatePost(newParams: postToEdit)
            if success { dismiss() }
        }
    }
    
    func delete() {
        Task {
            let success = await viewModel.deletePost(for: postToEdit)
            if success { dismiss () }
        }
    }
    
    func archive() {
        Task {
            let success = await viewModel.archivePost(for: postToEdit)
            if success { dismiss() }
        }
    }
    
    func updateData(from photoItem: PhotosPickerItem) { viewModel.updateImage(from: photoItem) { imageData = $0 } }
}

#Preview {
    EditPostView()
}
