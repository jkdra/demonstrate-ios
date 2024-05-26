//
//  ProfileManagement.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import PhotosUI
import Supabase
import SwiftUI

@Observable
class ProfileManagement {
    
    var loading = false
    let errHandler = ErrorHandler()
    
    @MainActor
    func saveProfile(newDispName: String, newBio: String, imageData: Data?) async -> Bool {
        do {
            let currentUser = try await auth.session.user
            let imageURL = try await uploadImage(imageData: imageData)
            
            let updatedProfile = Profile(
                displayName: newDispName,
                biography: newBio,
                imageURL: imageURL ?? ""
            )
            
            let updateStatus = try await database.from("profiles")
                .update(updatedProfile)
                .eq("id", value: currentUser.id)
                .execute()
            
            print("Successful Update: \(updateStatus)")
            return true
        } catch {
            print("ERROR UPDATING PROFILE: \(error)")
            errHandler.showError(error: .profile(.updateFailed))
            return false
        }
    }
    
    @MainActor
    func followUser(id: UUID) async -> Bool {
        do {
            let followResult = try await database.from("follows")
                .insert(["followed_id": id])
                .execute()
            
            print("Follow Successful: \(followResult)")
            return true
        } catch {
            print("ERROR FOLLOWING: \(error)")
            errHandler.showError(error: .profile(.unknown))
            return false
        }
    }
    
    @MainActor
    func unfollowUser(id: UUID) async -> Bool {
        do {
            try await database.from("follows")
                .delete()
                .eq("followed_id", value: id)
                .eq("follower_id", value: try await auth.session.user.id)
                .single()
                .execute()
            
            return true
        } catch {
            print("ERROR UNFOLLOWING: \(error)")
            errHandler.showError(error: .profile(.unknown))
            return false
        }
    }
    
    func fetchProfile(id: UUID, completion: @escaping (Profile) -> Void) async {
        do {
            let fetchedProfile: Profile = try await database.from("profiles")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            
            completion(fetchedProfile)
            
        } catch {
            print("ERROR FETCHING: \(error)")
            errHandler.showError(error: .profile(.userProfileNotFound))
        }
    }
    
    
    func updateUsername(newUsername: String) async {
        loading = true
        defer { loading = false }
        guard !newUsername.isEmpty else { return }
        
        do {
            let currentUser = try await auth.session.user
            
            let result = try await database.from("profiles")
                .update(["username": newUsername])
                .eq("id", value: currentUser.id)
                .execute()
            
            print(result)
        } catch {
            print("ERROR UPDATING USERNAME: \(error)")
            errHandler.showError(error: .profile(.unknown))
        }
    }
    
    func downloadImage(path: String, completionHandler: @escaping (Image?) -> Void) async throws {
        guard !path.isEmpty else { return }
        let data = try await supabase.storage.from("profile_images").download(path: path)
        let newUIImage = UIImage(data: data)!
        completionHandler(Image(uiImage: newUIImage))
    }
    
    private func uploadImage(imageData: Data?) async throws -> String? {
        guard let data = imageData else { return nil }
        
        let filePath = "\(UUID().uuidString).jpeg"
        
        try await supabase.storage
            .from("profile_images")
            .upload(
                path: filePath,
                file: data,
                options: FileOptions(contentType: "image/jpeg")
            )
        
        return filePath
    }
    
    func updateImage(from photoItem: PhotosPickerItem, completion: @escaping (Data) -> (Void)) {
        Task {
            do {
                guard let newData = try await photoItem.loadTransferable(type: Data.self) else { return }
                
                await MainActor.run { completion(newData) }
                
            } catch { print("Error Updating Image: \(error.localizedDescription)") }
        }
    }
}
