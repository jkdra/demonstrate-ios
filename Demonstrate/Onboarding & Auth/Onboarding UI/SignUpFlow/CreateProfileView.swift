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
    @State var success = false
    @State var displayName = ""
    @State var biography = ""
    @State var photoItem: PhotosPickerItem?
    @State var imageData: Data?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(verbatim: "One more thing...")
                .largeTitle()
            
            Text(verbatim: "Why not give your profile some flair?")
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
            .onChange(of: photoItem) {
                if let photoItem { updateImage(from: photoItem) }
            }
            .padding()
            TextField("Display Name", text: $displayName)
                .modifier(CustomTextFieldStyle())
            
            TextField("Bio", text: $biography, axis: .vertical)
                .frame(height: 48, alignment: .top)
                .modifier(CustomTextFieldStyle())
            
            
            Spacer()
            
            Button("Save Profile") { saveProfile() }
                .primaryButton()
        }
        .navigationBarBackButtonHidden()
        .padding()
        .overlay { FullscreenLoading(show: $profileManage.loading) }
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
