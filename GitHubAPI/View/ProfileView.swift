//
//  ProfileView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import SwiftUI

struct ProfileView: View {
    
    // MARK: - PROPERTIES
    
    @StateObject var vm = GHViewModel()
    
    @State var user: GHUser
    @State private var isLoading: Bool = true
    
    @State private var reposList: [Repo] = []
    @State private var followersList: [GHUser] = []
    @State private var followingList: [GHUser] = []
    
    @State private var searchTerm: String = ""
    var filteredFollowers: [GHUser] {
        guard !searchTerm.isEmpty else { return followersList }
        return followersList.filter { $0.login.localizedCaseInsensitiveContains(searchTerm) }
    }
    var filteredFollowing: [GHUser] {
        guard !searchTerm.isEmpty else { return followingList }
        return followingList.filter { $0.login.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    userMainInfo
                    userBio
                    userFollow
                    userRepos
                }
                .padding(16)
                .navigationTitle("Profile")
                .redacted(reason: isLoading ? .placeholder : [])
            }
        }
        .task {
            do {
                user = try await vm.getUser(login: user.login)
                isLoading = false
            } catch GHError.invalidURL {
                print("Error: Invalid URL.")
                isLoading = false
            } catch GHError.invalidResponse {
                print("Error: Invalid Response.")
                isLoading = false
            } catch GHError.invalidData {
                print("Error: Invalid Data.")
                isLoading = false
            } catch {
                print("Unknown Error.")
                isLoading = false
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    func truncateNumberIfNeeded(number: Int) -> String {
        if number >= 10000 && number < 1000000 {
            return String(number / 1000) + "k"
        } else if number >= 1000000 {
            return String(number / 1000000) + "M"
        } else {
            return String(number)
        }
    }
    
    func colorByLanguge(language: String) -> Color {
        switch language {
        case "Python", "C", "C#", "C++", "CSS":
                .blue
        case "Kotlin":
                .purple
        case "Java", "HTML", "Swift":
                .orange
        case "JavaScript":
                .yellow
        default:
                .secondary
        }
    }
}

// MARK: - COMPONENTS

extension ProfileView {
    
    private var userMainInfo: some View {
        HStack {
            AsyncImage(
                url: URL(string: user.avatarUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                } placeholder: {
                    Circle()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.gray)
                        .shadow(radius: 10)
                }

            VStack(alignment: .leading) {
                Text(user.name ?? "")
                    .font(.title2)
                    .bold()
                
                Text("@\(user.login)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    private var userBio: some View {
        Text(user.bio ?? "")
            .foregroundStyle(.secondary)
    }
    
    private var userFollow: some View {
        HStack {
            Image(systemName: "person.2")
            NavigationLink(destination: followers) {
                HStack {
                    Text("\(truncateNumberIfNeeded(number: user.followers ?? 0))")
                        .font(.headline)
                    Text("Followers")
                        .foregroundStyle(.secondary)
                }
            }
            Text("·")
            NavigationLink(destination: following) {
                Text("\(truncateNumberIfNeeded(number: user.following ?? 0))")
                    .font(.headline)
                Text("Following")
                    .foregroundStyle(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var userRepos: some View {
        VStack {
            ForEach(reposList, id: \.self) { repo in
                NavigationLink(destination: RepoView(repo: repo)) {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(repo.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Spacer()
                                AsyncImage(
                                    url: URL(string: user.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                            .padding(.horizontal, -5)
                                    } placeholder: {
                                        Circle()
                                            .frame(width: 30, height: 30)
                                            .padding(.horizontal, -5)
                                    }
                            }
                            
                            Text(repo.description ?? "")
                                .foregroundStyle(.secondary)
                            
                            HStack {
                                Circle()
                                    .fill(colorByLanguge(language: "\(repo.language ?? "")"))
                                    .frame(width: 15)

                                Text(repo.language ?? "")
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.top)
                        }
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(.secondary, lineWidth: 2)
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .onAppear {
            vm.getRepos(for: user.login, page: 1) { repos, errorMessage in
                guard let repos = repos else {
                    print("Error:", errorMessage ?? "Unknown error")
                    return
                }
                self.reposList = repos
            }
        }
    }
    
    private var followers: some View {
        List {
//            if filteredFollowers.isEmpty {
//                ContentUnavailableView.search(text: searchTerm)
//            } else {
                ForEach(filteredFollowers, id: \.self) { follower in
                    NavigationLink(destination: ProfileView(user: follower)) {
                        HStack {
                            AsyncImage(
                                url: URL(string: follower.avatarUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: 50, height: 50)
                            
                            Text(follower.login)
                                .font(.headline)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .navigationTitle("\(user.login) Followers")
                }
//            }
        }
        .searchable(text: $searchTerm, prompt: "Search User")
        .autocorrectionDisabled()
        .onAppear {
            vm.getFollowers(for: user.login, page: 1) { followers, errorMessage in
                guard let followers = followers else {
                    print("Error:", errorMessage ?? "Unknown error")
                    return
                }
                self.followersList = followers
            }
        }
    }
    
    private var following: some View {
        List {
//            if filteredFollowers.isEmpty {
//                ContentUnavailableView.search(text: searchTerm)
//            } else {
                ForEach(filteredFollowing, id: \.self) { follower in
                    NavigationLink(destination: ProfileView(user: follower)) {
                        HStack {
                            AsyncImage(
                                url: URL(string: follower.avatarUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(Circle())
                                } placeholder: {
                                    Circle()
                                        .foregroundStyle(.secondary)
                                }
                                .frame(width: 50, height: 50)
                            
                            Text(follower.login)
                                .font(.headline)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .navigationTitle("\(user.login) Following")
                }
//            }
        }
        .searchable(text: $searchTerm, prompt: "Search User")
        .autocorrectionDisabled()
        .onAppear {
            vm.getFollowing(for: user.login, page: 1) { followers, errorMessage in
                guard let followers = followers else {
                    print("Error:", errorMessage ?? "Unknown error")
                    return
                }
                self.followingList = followers
            }
        }
    }
    
}

#Preview {
    ProfileView(user: GHUser(login: "martiespinosa", name: "Marti", avatarUrl: "", bio: "", publicRepos: 0, followers: 0, following: 0))
}
