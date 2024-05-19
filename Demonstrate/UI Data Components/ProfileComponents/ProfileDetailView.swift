//
//  ProfileDetailView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import Supabase

struct ProfileDetailView: View {
    
    @State var viewModel: ProfileDetailsViewModel
    
    init(profileID: UUID) { self.viewModel = ProfileDetailsViewModel(profileID: profileID) }
    
    var body: some View {
        NavigationStack {
            
            if let profile = viewModel.profile {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .center, spacing: 12) {
                            Circle()
                                .frame(width: 84, height: 84)
                            
                            VStack (alignment: .leading, spacing: 4) {
                                
                                Text(!profile.displayName.isEmpty ? profile.displayName : profile.username ?? "")
                                    .titleCard()
                                
                                if !profile.displayName.isEmpty {
                                    Text(profile.username ?? "")
                                        .bodyCard()
                                }
                                
                                viewModel.followDisplay()
                            }
                        }
                        
                        if !viewModel.viewingSelf && !viewModel.alreadyFollowing {
                            Button("Follow", systemImage: "plus.circle.fill") {
                                
                            }
                            .primaryButton()
                        } else if !viewModel.viewingSelf && viewModel.alreadyFollowing {
                            Menu("Following", systemImage: "checkmark.circle.fill") {
                                Button("Unfollow", role: .destructive) {
                                    
                                }
                            }
                            .secondaryButton()
                        } else {
                            Button("Edit Profile", systemImage: "square.and.pencil") {
                                
                            }
                            .secondaryButton()
                        }
                        
                        
                        
                        Text("Biography")
                            .bodyCard()
                        
                        Section {
                            ForEach(0..<3) { _ in
                                PostCard()
                                    .padding(.vertical, -10)
                            }
                        } header: {
                            Text("Posts by this user:")
                                .sectionHeader()
                                .padding(.bottom, -12)
                        }
                    }
                }
                .contentMargins(16, for: .scrollContent)
                .customNavBar((!profile.displayName.isEmpty ? profile.displayName : profile.username) ?? "")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        ShareLink(item: "Hello!") {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                    if viewModel.viewingSelf {
                        ToolbarItem(placement: .secondaryAction) {
                            Button("Settings") {
                                
                            }
                        }
                    }
                    
                }
            } else { ProfileLoading() }
        }
    }
}

@Observable
class ProfileDetailsViewModel {
    
    let profileID: UUID
    var profile: Profile? = .init(username: "hello", displayName: "Hello", biography: "", imageURL: "")
    var errAlert = false
    var alreadyFollowing = false
    var viewingSelf = false
    var errMsg = ""
    var profilePosts = [any Post]()
    
    init(profileID: UUID) {
        self.profileID = profileID
        Task {
            await fetchProfile()
        }
    }
    
    @MainActor
    private func fetchProfile() async {
        do {
            
            let currentUserID = try await auth.session.user.id
            
            viewingSelf = profileID == currentUserID
            
            let profileResult: Profile = try await database.from("profiles")
                .select()
                .eq("id", value: profileID)
                .single()
                .execute()
                .value
            
            profile = profileResult
        } catch {
            print("ERROR FETCHING PROFILE: \(error.localizedDescription)")
        }
    }

    func postInteractionButton() -> some View {
        if !viewingSelf && !alreadyFollowing {
            return AnyView(
                Button("Follow", systemImage: "plus.circle.fill") {
                    // Action goes here
                }
                .primaryButton()
            )
        } else if !viewingSelf && alreadyFollowing {
            return AnyView(
                Menu("Following", systemImage: "checkmark.circle.fill") {
                    Button("Unfollow", role: .destructive) {
                        // Action goes here
                    }
                }
                .secondaryButton()
            )
        } else {
            return AnyView(
                Button("Edit Profile", systemImage: "") {
                    // Action goes here
                }
                .secondaryButton()
            )
        }
    }

    
    func fetchPosts() async throws {
        
    }
    
    func followUser() async {
        
    }
    
    // This function fetches all the followers except for the current user, if the user follows them.
    func fetchFollowers() -> String {
        
        Task {
            do {
                let followerCount: Int = try await database.from("follows")
                    .select()
                    .eq("followed_id", value: profileID)
                // the user is intentionally omitted to provide "real time" updates in the event the user follows / unfollows this other user.
                    .neq("follower_id", value: try await auth.session.user.id)
                    .execute()
                    .count ?? 0 + (alreadyFollowing ? 1 : 0)
                
                return "\(formatNumber(followerCount))"
            } catch {
                print("ERROR FETCHING FOLLOWERS: \(error)")
                return ""
            }
        }
        return ""
    }
    
    func followDisplay() -> some View {
        HStack(spacing: 10) {
            Text("**\(fetchFollowers())** Followers")
                
            Divider()
                .padding(.vertical, 6)
            
            Text("**\(fetchFollowing())** Following")
        }
        .foregroundStyle(.primary)
        .bodyCard()
    }
    
    // Fetches the count of all the people the profile currently displayed is following.
    func fetchFollowing() -> String {
        Task {
            do {
                let followingCount: Int = try await database.from("follows")
                    .select()
                    .neq("follower_id", value: profileID)
                    .execute()
                    .count ?? 0
                
                return "\(formatNumber(followingCount))"
            } catch {
                print("ERROR GRABBING FOLLOWING: \(error)")
                return ""
            }
        }
        return ""
    }
    
    // This formats the numbers in a more user friendly manner (1k, 20.2k for example instead of 1,000 or 20,200)
    func formatNumber(_ number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.roundingMode = .halfUp

        let divisionValue: Double
        let suffix: String
        switch number {
        case 1_000..<(1_000 * 1_000):
            divisionValue = 1_000
            suffix = "k"
        case 1_000_000..<(1_000 * 1_000_000):
            divisionValue = 1_000_000
            suffix = "m"
        default:
            divisionValue = 1
            suffix = ""
        }
        
        let decimalValue = Double(number) / divisionValue
        let integralPart = Int(decimalValue)
        let fractionalPart = decimalValue - Double(integralPart)

        if fractionalPart == 0 {
            numberFormatter.maximumFractionDigits = 0
        } else {
            numberFormatter.maximumFractionDigits = 1
        }
        
        numberFormatter.positiveSuffix = suffix
        numberFormatter.multiplier = NSNumber(value: 1 / divisionValue)
        return numberFormatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    func showError(errorMessage: String) {
        errMsg = errorMessage
        errAlert = true
    }
}

#Preview {
    ProfileDetailView(profileID: UUID())
}
