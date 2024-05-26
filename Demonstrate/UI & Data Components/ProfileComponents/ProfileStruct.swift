//
//  ProfileStruct.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/10/24.
//

import Foundation

struct Profile: Codable, Identifiable, Hashable {
    
    var id: UUID?
    var username: String?
    var displayName: String
    var biography: String
    var imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id, username, biography
        case displayName = "display_name"
        case imageURL = "image_url"
    }
    
    
    static func profile1() -> Profile {
        .init(username: "jawadalkhadra", displayName: "Jawad Khadra", biography: "This is a biography to make sure the profile page works correctly.", imageURL: "")
    }
}
