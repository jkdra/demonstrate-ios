//
//  PostManagement.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import Foundation
import PhotosUI
import Supabase
import SwiftUI

enum PostManagementError: LocalizedError {
    case uploadFailed
    case archiveFailed
    case deleteFailed
    case signatureFailed
    case endorsementFailed
    case interestFailed
    
    var errorTitle: String? {
        switch self {
        case .uploadFailed: "Upload Failed"
        case .archiveFailed: "Archive Failed"
        case .deleteFailed: "Delete Failed"
        case .signatureFailed: "Signature Failed"
        case .endorsementFailed: "Endorsement Failed"
        case .interestFailed: "Interest Failed"
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .uploadFailed:
            "So your post decided not to cooperate... Please try again."
        case .archiveFailed:
            "Damn, this post must really love the attention. In all seriousness though something went wrong."
        case .deleteFailed:
            "Something went wrong while deleting your post. Please try again."
        case .signatureFailed:
            "Something went wrong while signing your post. Please try again."
        case .endorsementFailed:
            "Something went wrong while endorsing your post. Please try again."
        case .interestFailed:
            "Something went wrong while interest your post. Please try again."
        }
    }
}

@Observable
class PostManagementViewModel {
    
    var loading = false
    var error = false
    var errMsg = ""
    
    func createPost(post: any Post, completion: @escaping (Bool) -> (Void)) async throws {
        loading = true
        defer { loading = false }
        let response = try await database.from(post.postType == .petition ? "petitions" : "events")
            .insert(post)
            .execute()
        
        print("Post Upload Successful!: \(response)")
        completion(true)
    }
    
    func archivePost(for post: any Post) async -> Bool {
        loading = true
        defer { loading = false }
        do {
            guard let postID = post.id else { return false }
            
            let response = try await database.from(post.postType == .petition ? "petitions" : "events")
                .update(["archived": false])
                .eq("id", value: postID)
                .eq("author_id", value: try await auth.session.user.id)
                .single()
                .execute()
            
            print("Archive Successful: \(response)")
            return true
        } catch {
            print("ERROR ARCHIVING: \(error)")
            showError(errorMessage: error.localizedDescription)
            return false
        }
    }
    
    func deletePost(for post: any Post) async -> Bool {
        loading = true
        defer { loading = false }
        do {
            guard let postID = post.id else { return false }
            
            let response = try await database.from(post.postType == .petition ? "petitions" : "events")
                .delete()
                .eq("id", value: postID)
                .eq("author_id", value: try await auth.session.user.id)
                .single()
                .execute()
            
            print("Delete Successful: \(response)")
            return true
        } catch {
            print("ERROR DELETING: \(error)")
            showError(errorMessage: error.localizedDescription)
            return false
        }
    }
    
    func updatePost(newParams: any Post) async -> Bool {
        loading = true
        defer { loading = false }
        do {
            guard let id = newParams.id else { return false }
            let response = try await database.from(newParams.postType == .petition ? "petitions" : "events")
                .update(newParams)
                .eq("id", value: id)
                .eq("author_id", value: try await auth.session.user.id)
                .execute()
            print("Update Successful: \(response)")
            return true
        } catch {
            print("ERROR UPDATING \(newParams.postType.postTitle.uppercased()): \(error)")
            showError(errorMessage: error.localizedDescription)
            return false
        }
    }
    
    func updateImage(from photoItem: PhotosPickerItem, completion: @escaping (Data) -> (Void)) {
        Task {
            do {
                guard let newData = try await photoItem.loadTransferable(type: Data.self) else { return }
                
                await MainActor.run { completion(newData) }
                
            } catch { print("Error Updating Image: \(error.localizedDescription)") }
        }
    }
    
    func showError(errorMessage: String) {
        error = true
        errMsg = errorMessage
    }
}
