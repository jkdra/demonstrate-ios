//
//  CreateProfileView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import SwiftUI
import PhotosUI

struct CreateProfileView: View {
    
    @Bindable var profileManage = ProfileManagement()
    @Binding var isPresented: Bool
    @FocusState private var focus: Bool
    @State private var success = false
    @State private var confirmProfileSkip = false
    @State private var displayName = ""
    @State private var biography = ""
    @State private var photoItem: PhotosPickerItem?
    @State private var imageData: Data?
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(verbatim: "One more thing...")
                    .largeTitle()
                
                Text(verbatim: "A little set up for your profile wouldn't hurt.")
                    .headline()
                
                PhotosPicker(selection: $photoItem) {
                    Group {
                        if let imageData, let image = UIImage(data: imageData) {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(.circle)
                        } else {
                            Circle()
                                .foregroundStyle(.tertiary)
                                .overlay {
                                    Image(systemName: "photo.on.rectangle")
                                        .font(.largeTitle)
                                }
                        }
                    }
                    .frame(width: 128, height: 128)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .onChange(of: photoItem) { if let photoItem { updateImage(from: photoItem) } }
                .padding()
                TextField("Display Name", text: $displayName)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
                
                TextField("Bio", text: $biography, axis: .vertical)
                    .frame(height: 48, alignment: .top)
                    .modifier(CustomTextFieldStyle())
                    .focused($focus)
                
                Spacer()
                
                if !focus {
                    Button("Save Profile") { saveProfile() }
                        .primaryButton()
                } else {
                    Button("Done") { focus = false }
                        .hAlign(.leading)
                        .padding(.top)
                        .font(.custom("Unbounded", size: 14))
                        .background(.regularMaterial)
                }
                
            }
            .navigationBarBackButtonHidden()
            .safeAreaPadding()
            .overlay { FullscreenLoading(show: $profileManage.loading) }
            .confirmationDialog("Skip Profile Setup?", isPresented: $confirmProfileSkip, titleVisibility: .visible) {
                
                Button("Skip Setup", role: .destructive) { isPresented = false }
                
                Button("Continue", role: .cancel) { }
                
            } message: { Text("You can always edit your profile later.") }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip Setup") { confirmProfileSkip = true }
                        .font(.custom("Unbounded", size: 14))
                }
            }
        }
    }
    
    func updateImage(from photoItem: PhotosPickerItem) {
        Task {
            do {
                guard let newData = try await photoItem.loadTransferable(type: Data.self) else { return }
                await MainActor.run { imageData = newData }
            } catch {
                print("Error Updating Image: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func saveProfile() {
        Task { success = await profileManage.saveProfile(newDispName: displayName, newBio: biography, imageData: imageData) }
    }
}

#Preview {
    CreateProfileView(isPresented: .constant(true))
}
