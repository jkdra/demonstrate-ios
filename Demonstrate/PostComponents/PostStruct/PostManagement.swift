//
//  PostManagement.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import Foundation
import Supabase

@Observable
class PostManagementViewModel {
    
    func createPost(post: any Post, completion: @escaping (Bool) -> (Void)) async throws {
        
        let response = try await database.from("petitions")
            .insert(post)
            .execute()
        
        print("Post Upload Successful!: \(response)")
        
        completion(true)
    }
    
    func deletePost(postID: Int) async throws {
        
        let userID = try await auth.session.user.id
        
        let response = try await database.from("petitions")
            .delete()
            .eq("id", value: postID)
            .eq("author_id", value: userID)
            .single()
            .execute()
        
        print("Delete Successful: \(response)")
    }
    
    func updatePost() async throws {
        
    }
}
