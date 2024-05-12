//
//  ProfileManagement.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation
import Supabase
import SwiftUI

@Observable
class ProfileManagement {
    
    var loading = false
    
    func saveProfile(newDispName: String, newBio: String, imageData: Data?) async {
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
        } catch {
            print("ERROR UPDATING PROFILE: \(error.localizedDescription)")
        }
    }
    
    func fetchProfile(with id: UUID, completion: @escaping (Profile) -> Void) async {
        do {
            
            let fetchedProfile: Profile = try await database.from("profiles")
                .select()
                .eq("id", value: id)
                .single()
                .execute()
                .value
            
            completion(fetchedProfile)
            
        } catch {
            print("ERROR FETCHING: \(error.localizedDescription)")
        }
    }
    
    
    func updateUsername(newUsername: String) async throws {
        loading = true
        defer { loading = false }
        guard !newUsername.isEmpty else { return }
        
        let currentUser = try await auth.session.user
        
        let result = try await database.from("profiles")
            .update(["username": newUsername])
            .eq("id", value: currentUser.id)
            .execute()
        
        print(result)
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
    
    private func updateImage() async throws {
        
    }
}
