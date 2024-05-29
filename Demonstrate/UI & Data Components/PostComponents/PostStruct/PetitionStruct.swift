//
//  PetitionStruct.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/16/24.
//

import Foundation

struct Petition: Post {
    var id: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var title: String
    var summary: String
    var description: String
    var userID: UUID?
    var topic: Topic
    var archived: Bool = false
    var imagePath: String
    var postType: PostType = .petition
    var signatureGoal: Int
    
    enum CodingKeys: String, CodingKey {
        case id, title, summary, description, topic, archived
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userID = "user_id"
        case imagePath = "image_path"
        case postType = "post_type"
        case signatureGoal = "signature_goal"
    }
    
    static func petition1() -> Petition {
        .init(
            title: "Make Healthcare Cheaper!",
            summary: "Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat. Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat.",
            description: "Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim. Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim.",
            topic: .healthcare,
            imagePath: "https://picsum.photos/1152/864", 
            signatureGoal: 100
        )
    }
    
    static func petition2() -> Petition {
        .init(
            title: "Enforce Gun Control!",
            summary: "Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat. Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat.",
            description: "Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim. Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim.",
            topic: .publicSafety,
            imagePath: "https://picsum.photos/1152/864", 
            signatureGoal: 100
        )
    }
    
    static func petition3() -> Petition {
        .init(
            title: "Bring Back TikTok!",
            summary: "Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat. Non magna veniam sint dolor ea pariatur sit do do cupidatat sunt duis magna eu occaecat.",
            description: "Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim. Elit labore officia cillum in ullamco adipisicing proident dolore. Pariatur nisi dolore non cillum eiusmod aute anim ex. Exercitation nisi nostrud ut aute ipsum exercitation nulla. Et consectetur do enim dolore commodo. Nulla in irure laborum fugiat anim.",
            topic: .politics,
            imagePath: "https://picsum.photos/1152/864", 
            signatureGoal: 100
        )
    }
    
    static func petitions() -> [Petition] { [ petition1(), petition2(), petition3() ] }
}
