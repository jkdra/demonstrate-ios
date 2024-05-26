//
//  EventStruct.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/16/24.
//

import Foundation

struct Event: Post {
    var id: Int?
    var createdAt: Date?
    var updatedAt: Date?
    var title: String
    var summary: String
    var description: String
    var authorID: UUID?
    var topic: Topic
    var archived: Bool = false
    var imageURL: String
    var postType: PostType = .event
    var startsAt: Date
    var endsAt: Date
    var location: String
    
    enum CodingKeys: String, CodingKey {
        case id, title, summary, description, topic, archived, location
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case authorID = "author_id"
        case imageURL = "image_url"
        case postType = "post_type"
        case startsAt = "starts_at"
        case endsAt = "ends_at"
    }
    
    static func event1() -> Event {
        .init(
            title: "",
            summary: "",
            description: "",
            topic: .economy,
            imageURL: "",
            startsAt: Date(),
            endsAt: Date(),
            location: ""
        )
    }
    
    static func event2() -> Event {
        .init(
            title: "",
            summary: "",
            description: "",
            topic: .economy,
            imageURL: "",
            startsAt: Date(),
            endsAt: Date(),
            location: ""
        )
    }
    
    static func event3() -> Event {
        .init(
            title: "",
            summary: "",
            description: "",
            topic: .economy,
            imageURL: "",
            startsAt: Date(),
            endsAt: Date(),
            location: ""
        )
    }
    
    static func events() -> [Event] {
        [
            event1(),
            event2(),
            event3()
        ]
    }
}
