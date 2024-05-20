//
//  EditProfileView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/15/24.
//

import SwiftUI
import PhotosUI
import NukeUI
import Supabase

struct EditProfileView: View {
    
    @FocusState private var focus: Bool
    @Environment(\.dismiss) private var dismiss
    @Bindable private var profileManagement = ProfileManagement()
    @State private var profileToEdit: Profile = .init(displayName: "", biography: "", imageURL: "")
    @State private var photoItem: PhotosPickerItem?
    @State private var imgData: Data?
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 10) {
                
                Text("Hmm, yeah I can see why you had to go to this screen.")
                    .headline()
                    .hAlign(.leading)
                
                PhotosPicker(selection: $photoItem, matching: .images) {
                    LazyImage(url: URL(string: loadImageURL(imgPath: profileToEdit.imageURL))) { state in
                        if let imageData = imgData, let uiimg = UIImage(data: imageData) {
                            Image(uiImage: uiimg)
                                .resizable()
                        } else {
                            if let image = state.image {
                                image
                                    .resizable()
                            } else {
                                Circle()
                                    .foregroundStyle(.tertiary)
                                    .overlay {
                                        Image(systemName: "photo.on.rectangle")
                                            .font(.largeTitle)
                                    }
                            }
                        }
                    }
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 128, height: 128)
                .clipShape(.circle)
                .onChange(of: photoItem) { updateImage() }
                .padding(.vertical)
                
                TextField("Display Name", text: $profileToEdit.displayName)
                    .textContentType(.name)
                    .autocorrectionDisabled()
                    .modifier(CustomTextFieldStyle())
                
                TextField("Bio", text: $profileToEdit.biography, axis: .vertical)
                    .frame(height: 48, alignment: .top)
                    .modifier(CustomTextFieldStyle())
                
                Spacer()
                
                Button("Save Changes") {
                    AppSettingsManager().primaryButtonHaptic()
                }
                .primaryButton()
            }
            .safeAreaPadding(.horizontal)
            .safeAreaPadding(.bottom)
            .overlay { FullscreenLoading(show: $profileManagement.loading)}
            .customNavBar("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .font(.custom("Unbounded", size: 14))
                }
            }
        }
    }
    
    @MainActor
    private func updateImage() {
        guard let photoItem = photoItem else { return }
        
        Task {
            do {
                imgData = try await photoItem.loadTransferable(type: Data.self)
            } catch {
                print("ERROR UPDATING PHOTO: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    private func fetchProfile() {
        Task {
            do {
                let currentUser = try await auth.session.user.id
                
                await profileManagement.fetchProfile(id: currentUser) { profile in
                    profileToEdit.displayName = profile.displayName
                    profileToEdit.biography = profile.biography
                    profileToEdit.imageURL = profile.imageURL
                }
            } catch {
                print("ERROR FETCHING PROFILE: \(error.localizedDescription)")
            }
        }
    }
    
    
    func loadImageURL(imgPath: String) -> String {
        Task {
            do {
                let imgLoadableURL = try supabase.storage.from("profile_images")
                    .getPublicURL(path: imgPath)
                    .absoluteString
                
                return imgLoadableURL
            } catch {
                print("ERROR FINDING PROFILE IMAGE: \(error.localizedDescription)")
            }
            return ""
        }
        return ""
    }
    
    func saveProfile() {
        Task {
            await profileManagement.saveProfile(newDispName: profileToEdit.displayName, newBio: profileToEdit.biography, imageData: imgData)
        }
    }
}

#Preview {
    EditProfileView()
}
