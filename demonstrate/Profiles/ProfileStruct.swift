//
//  Profile.swift
//  demonstrate
//
//  Created by Jawad Khadra on 1/15/25.
//

import Foundation
import Observation

struct Profile: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var email: String
}

@Observable
final class ProfileModel {
    var profiles: [Profile] = []
    
    func addProfile(_ profile: Profile) {
        profiles.append(profile)
    }
}
