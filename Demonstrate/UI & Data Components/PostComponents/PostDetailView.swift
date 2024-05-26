//
//  PostDetailView.swift
//  Demonstrate
//
//  Created by Jawad Khadra on 5/15/24.
//

import SwiftUI
import Supabase
import NukeUI

struct PostDetailView: View {
    
    var viewModel: PostDetailViewModel
    @State private var showHeader = false
    @State private var editPost = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.verticalSizeClass) private var heightClass
    @Environment(\.horizontalSizeClass) private var widthClass
    
    var iphoneView: Bool { heightClass == .regular && widthClass == .compact ? true : false }
    
    
    init(post: any Post = Petition.petition1()) {
        viewModel = PostDetailViewModel(post: post)
    }
    
    var body: some View {
        
        let post = viewModel.post
        
        ScrollView {
            LazyImage(url: URL(string: post.imageURL)) { state in
                if let image = state.image { image.resizable() } else { Color.accentColor }
            }
            .aspectRatio(contentMode: .fill)
            .asStretchyHeader(startingHeight: UIScreen.main.bounds.height / 2.2)
            .readingFrame { showHeader = $0.maxY < 145 }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 10) {
                    NavigationLink {
                        
                    } label: {
                        HStack(spacing: 10) {
                            Circle()
                                .frame(width: 14, height: 14)
                            
                            Text("Author")
                                .foregroundStyle(.secondary)
                                .titleCard()
                        }
                    }
                    .foregroundStyle(.primary)
                    
                    Text("Title")
                        .font(.custom("Unbounded-Regular_Bold", size: 24))
                }
                .padding()
                .safeAreaPadding(.top, 24)
                .hAlign(.leading)
                .background {
                    LinearGradient(colors: [Color(uiColor: .systemBackground), .clear], startPoint: .init(x: 0, y: 0.8), endPoint: .init(x: 0, y: 0))
                }
                
            }
            Grid(alignment: .center) {
                
                ForEach(0..<50) { _ in
                    Text("Hello")
                }
                
            }
            VStack(spacing: 12) {
                
                Text("Fugiat elit proident culpa laborum nostrud culpa veniam esse nisi irure aute anim esse magna culpa.")
                    .bodyPage()
                
                Section {
                    VStack {
                        if viewModel.userIsAuthor {
                            Button("Edit \(post.postType.postTitle)", systemImage: "square.and.pencil") {
                                AppSettingsManager().primaryButtonHaptic()
                                editPost = true
                            }
                            .secondaryButton()
                            .sheet(isPresented: $editPost) { EditPostView(postToEdit: post) }
                        } else if post is Petition {
                            if !viewModel.alreadySigned {
                                Button("Sign Petition", systemImage: "signature") {
                                    AppSettingsManager().primaryButtonHaptic()
                                }
                                .primaryButton()
                            } else {
                                Menu("Signed", systemImage: "checkmark") {
                                    Button("Unsign Petition", role: .destructive) {
                                        
                                    }
                                }
                                .secondaryButton()
                            }
                        } else if post is Event {
                            if !viewModel.alreadyInterested {
                                
                            } else {
                                
                            }
                        }
                    }
                    
                    HStack {
                        Button {
                            AppSettingsManager().primaryButtonHaptic()
                        } label: {
                            Label("Ask Quill", image: "quillicon.final")
                        }
                        .secondaryButton()
                        
                        Button {
                            
                        } label: {
                            Label("Endorse", image: "endorsement.fill")
                        }
                        .secondaryButton()
                    }
                } header: {
                    Text("Overview")
                        .sectionHeader()
                }
                
                Section {
                    
                } header: {
                    Text("Description")
                        .sectionHeader()
                }
            }
            
            .safeAreaPadding(.horizontal)
        }
        .overlay(alignment: .top) { header }
    }
    
    var header: some View {
        ZStack {
            Text("Title")
                .padding(10)
                .font(.custom("Unbounded-Regular_Semibold", size: 16))
                .hAlign(.center)
                .background(.regularMaterial)
                .overlay(alignment: .bottom) { Divider() }
                .offset(y: showHeader ? 0 : -50)
                .opacity(showHeader ? 1 : 0)
            
            Button { dismiss() }
            label: {
                Image(systemName: "chevron.left")
                    .bold()
                    .padding(8)
                    .background {
                        if !showHeader {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                    }
            }
            .hAlign(.leading)
            .foregroundStyle(.primary)
            .padding(.leading, 12)
                
            
            Menu {
                Button("View Author") {
                    
                }
                
                Button("Report Post", role: .destructive) {
                    
                }
            } label: {
                Image(systemName: "ellipsis")
                    .bold()
                    .padding(10)
                    .background {
                        if !showHeader {
                            Circle()
                                .fill(.ultraThinMaterial)
                        }
                    }
            }
            .hAlign(.trailing)
            .foregroundStyle(.primary)
            .padding(.trailing, 10)
        }
        .animation(.snappy(duration: 0.2), value: showHeader)
    }
}

@Observable
class PostDetailViewModel {
    
    let post: any Post
    var userIsAuthor = false
    var alreadySigned = false
    var alreadyInterested = false
    var alreadyEndorsed = false
    
    init(post: any Post) {
        self.post = post
        
        // This segment checks if the current user is the author of the post displayed
        guard let authorID = post.authorID else { return }
        Task {
            let userID = try? await auth.session.user.id
            await MainActor.run { userIsAuthor = userID == authorID }
        }
    }
    
    func fetchSignatures() {
        
    }
    
    func fetchInterests() {
        
    }
    
}

extension View {
    func bodyPage() -> some View {
        self.modifier(CustomPageBodyStyle())
    }
}

struct CustomPageBodyStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Unbounded-Regular", size: 16))
            .foregroundStyle(.secondary)
            .lineSpacing(4)
            .hAlign(.leading)
        
    }
}

#Preview {
    PostDetailView()
}
