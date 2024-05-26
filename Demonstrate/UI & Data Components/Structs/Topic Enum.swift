//
//  Topic Enum.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/13/24.
//

import Foundation
import SwiftUI

enum Topic: String, Codable {
    case environment
    case healthcare
    case education
    case politics
    case humanRights = "human_rights"
    case film
    case gaming
    case tech
    case industry
    case economy
    case publicSafety = "public_safety"
    case mentalHealth = "mental_health"
    case sports
    case art
    case socialServices = "social_services"
    case other

    var title: String {
        switch self {
        case .environment:
            return "Environment"
        case .healthcare:
            return "Healthcare"
        case .education:
            return "Education"
        case .politics:
            return "Politics"
        case .humanRights:
            return "Human Rights"
        case .film:
            return "Film"
        case .gaming:
            return "Gaming"
        case .tech:
            return "Tech"
        case .industry:
            return "Industry"
        case .economy:
            return "Economy"
        case .publicSafety:
            return "Public Safety"
        case .mentalHealth:
            return "Mental Health"
        case .sports:
            return "Sports"
        case .art:
            return "Art & Culture"
        case .socialServices:
            return "Social Services"
        case .other:
            return "Other"
        }
    }
    
    var systemImage: String {
        switch self {
        case .environment:
            "leaf.fill"
        case .healthcare:
            "waveform.path.ecg.rectangle.fill"
        case .education:
            "graduationcap.fill"
        case .politics:
            "building.columns.fill"
        case .humanRights:
            "person.2.fill"
        case .film:
            "film.fill"
        case .gaming:
            "gamecontroller.fill"
        case .tech:
            "externaldrive.connected.to.line.below.fill"
        case .industry:
            "book.and.wrench"
        case .economy:
            "dollarsign.arrow.circlepath"
        case .publicSafety:
            "exclamationmark.shield.fill"
        case .mentalHealth:
            "heart.fill"
        case .sports:
            "sportscourt.fill"
        case .art:
            "theatermask.and.paintbrush.fill"
        case .socialServices:
            "accessibility.fill"
        case .other:
            "globe"
        }
    }
    
    var colorHex: Color {
        switch self {
        case .environment:
            Color(hex: "13B576")
        case .healthcare:
            Color(hex: "108CD4")
        case .education:
            Color(hex: "E5C326")
        case .politics:
            Color(hex: "D8113F")
        case .humanRights:
            Color(hex: "B628D1")
        case .film:
            Color(hex: "404040")
        case .gaming:
            Color(hex: "3BB4C7")
        case .tech:
            Color(hex: "D7228A")
        case .industry:
            Color(hex: "CF5824")
        case .economy:
            Color(hex: "81C046")
        case .publicSafety:
            Color(hex: "1B48A5")
        case .mentalHealth:
            Color(hex: "6421BB")
        case .sports:
            Color(hex: "C41916")
        case .art:
            Color(hex: "A10064")
        case .socialServices:
            Color(hex: "2A90F1")
        case .other:
            Color(hex: "929292")
        }
    }
    
    static func allTopics() -> [Topic] {
        [.environment, .healthcare, .education, .politics, .humanRights, .film, .gaming, .tech, .industry, .economy, .publicSafety, .mentalHealth, .sports, .art, .socialServices, .other]
    }
}

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}
