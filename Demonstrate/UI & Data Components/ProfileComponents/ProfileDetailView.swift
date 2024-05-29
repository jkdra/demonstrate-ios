//
//  ProfileDetailView.swift
//  demonstrate
//
//  Created by Jawad Khadra on 5/11/24.
//

import SwiftUI
import NukeUI
import Supabase

struct ProfileDetailView: View {
    
    @State var viewModel: ProfileDetailsViewModel
    @State private var properImgURL: URL?
    @State private var showSettings = false
    @State private var editProfile = false
    
    init(profileID: UUID) { viewModel = ProfileDetailsViewModel(profileID: profileID) }
    
    var body: some View {
        NavigationStack {
            if let profile = viewModel.profile {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .center, spacing: 12) {
                            LazyImage(url: properImgURL ?? URL(string: "")) { state in
                                if let image = state.image {
                                    image.resizable()
                                } else if state.error != nil {
                                    Image("NoPFP")
                                        .resizable()
                                } else { ShimmerEffect() }
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 84, height: 84)
                            .clipShape(.circle)
                            
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
                        
                        if viewModel.viewingSelf {
                            Button("Edit Profile", systemImage: "square.and.pencil") {
                                settingManager.primaryButtonHaptic()
                                editProfile = true
                            }
                            .secondaryButton()
                            .sheet(isPresented: $editProfile) { EditProfileView() }
                        } else if viewModel.alreadyFollowing {
                            Menu("Following", systemImage: "checkmark.circle.fill") {
                                Button("Unfollow", role: .destructive) {
                                    
                                }
                            }
                            .secondaryButton()
                        } else {
                            Button("Follow", systemImage: "plus.circle.fill") {
                                settingManager.primaryButtonHaptic()
                                
                            }
                            .primaryButton()
                        }
                        
                        Text(profile.biography)
                            .bodyCard()
                        
                        Section {
                            if !viewModel.profilePosts.isEmpty {
                                VStack {
                                    ForEach(viewModel.profilePosts) { post in
                                        PostCard(post: post)
                                            .onAppear {
                                                if post == viewModel.profilePosts.last {
                                                    Task { try? await viewModel.fetchPosts() }
                                                }
                                            }
                                    }
                                }
                            } else {
                                ContentUnavailableView {
                                    Label("No Posts from this user", systemImage: "square.stack.3d.up.slash.fill")
                                        .titleCard()
                                } description: {
                                    Text("Damn, someone tell them?")
                                        .bodyCard()
                                        .padding(.top, 6)
                                }
                            }
                            
                        } header: {
                            Text("Posts by this user:")
                                .sectionHeader()
                        }
                    }
                }
                .contentMargins(16, for: .scrollContent)
                .customNavBar((!profile.displayName.isEmpty ? profile.displayName : profile.username) ?? "")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Menu("Profile Options", systemImage: "ellipsis.circle") {
                            if !viewModel.viewingSelf {
                                Button("Report User", role: .destructive) {
                                    
                                }
                            } else {
                                Button("Settings") {
                                    
                                }
                            }
                            
                        }
                        .symbolRenderingMode(.hierarchical)
                    }
                    
                }
            } else { ProfileLoading().disabled(true) }
        }
        .task {
            await viewModel.fetchProfile()
            let stringToConvert = await loadImgURLString()
            properImgURL = URL(string: stringToConvert)
        }
    }
    
    @MainActor
    func loadImgURLString() async -> String {
        await viewModel.fetchProfile()
        guard let profile = viewModel.profile else { return "Failed 1" }
        do {
            let actualURL = try supabase.storage.from("profile_images")
                .getPublicURL(path: profile.imageURL)
                .absoluteString
            
            return actualURL
        } catch {
            print("ERROR LOADING PFP URL: \(error.localizedDescription)")
            return "Failed..."
        }
    }
}

@Observable
class ProfileDetailsViewModel {
    
    let profileID: UUID
    let errHandler = ErrorHandler()
    var profile: Profile?
    var followerCount: Int = 0
    var followingCount: Int = 0
    var alreadyFollowing = false
    var editProfile = false
    var viewingSelf = false
    var profilePosts = [Petition]()
    
    private var currentPage = 0
    private var pageSize = 5
    private var morePostsAvailable = true
    
    init(profileID: UUID) {
        self.profileID = profileID
        Task { await fetchProfile() }
    }
    
    @MainActor
    func fetchProfile() async {
        do {
            
//            let currentUserID = try await auth.session.user.id
//            viewingSelf = profileID == currentUserID
            
            let profileResult: Profile = try await database.from("profiles")
                .select()
                .eq("id", value: profileID)
                .single()
                .execute()
                .value
            
            profile = profileResult
            
            try await fetchPosts()
            
        } catch {
            print("ERROR FETCHING PROFILE: \(error.localizedDescription)")
            errHandler.showError(error: .profile(.userProfileNotFound))
        }
    }
    
    @MainActor
    func fetchPosts() async throws {
        
        guard morePostsAvailable else { return }
        
        let fromIndex = currentPage * pageSize
        let toIndex = fromIndex + pageSize - 1
        
        let fetchedPosts: [Petition] = try await database.from("petitions")
            .select()
            .eq("user_id", value: profileID)
            .range(from: fromIndex, to: toIndex)
            .execute()
            .value
        
        if fetchedPosts.count < 2 { morePostsAvailable = false }
        
        profilePosts.append(contentsOf: fetchedPosts)
        currentPage += 1
    }
    
    func followUser() async {
        do {
            let followResult = try await database.from("follows")
                .insert(["followed_id": profileID])
                .execute()
            
            print("Follow Successful: \(followResult)")
            self.alreadyFollowing = true
        } catch {
            print("ERR DEBUG: \(error)")
            errHandler.showError(error: .profile(.unknown))
        }
    }
    
    func unfollowUser() async {
        do {
            let unfollowResult = try await database.from("follows")
                .delete()
                .eq("follower_id", value: try await auth.session.user.id)
                .eq("followed_id", value: profileID)
                .single()
                .execute()
            
            print("Unfollow Successful: \(unfollowResult)")
            self.alreadyFollowing = false
        } catch {
            print("ERROR UNFOLLOWING USER: \(error.localizedDescription)")
            errHandler.showError(error: .profile(.unknown))
        }
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
                return "0"
            }
        }
        return "0"
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
                return "0"
            }
        }
        return "0"
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
}


// This ID is my own account I created on the app, used to test it out and make sure profle updates are working
#Preview {
    ProfileDetailView(profileID: UUID(uuidString: "92861c19-7e49-40f3-94e2-c8b64bea6129")!)
}
