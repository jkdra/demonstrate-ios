//
//  Post Protocol.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/12/24.
//

import Foundation
import SwiftUI

enum PostType: String, Codable {
    case petition, event
    
    var postTitle: String {
        switch self {
        case .petition: "Petition"
        case .event: "Event"
        }
    }
    
    var postLabel: some View {
        switch self {
        case .petition:
            ContentUnavailableView {
                Label("Petition", systemImage: "signature")
                    .font(.custom("Unbounded", size: 16))
            } description: {
                Text("Show support through signatures.")
                    .font(.custom("Unbounded", size: 12))
            }
        case .event:
            ContentUnavailableView {
                Label("Event", systemImage: "calendar.badge.clock")
                    .font(.custom("Unbounded", size: 16))
            } description: {
                Text("These will come in a future update!")
                    .font(.custom("Unbounded", size: 12))
            }
        }
    }
}

protocol Post: Identifiable, Codable, Hashable {
    var id: Int? { get }
    var createdAt: Date? { get }
    var updatedAt: Date? { get }
    var title: String { get set }
    var summary: String { get set }
    var description: String { get set }
    var authorID: UUID? { get }
    var topic: Topic { get set }
    var archived: Bool { get set }
    var imageURL: String { get set }
    var postType: PostType { get set }
}
