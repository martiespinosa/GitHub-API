//
//  ProfileView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State var user: GHUser
    @State private var pickerSelection: Int = 1
    
    @State private var reposList: [Repo] = []
    @State private var followersList: [GHUser] = []
    @State private var followingList: [GHUser] = []
    
    var body: some View {
        NavigationStack {
            //ScrollView {
                VStack(alignment: .leading, spacing: 25) {
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
                    
                    Text(user.bio ?? "")
                        .foregroundStyle(.secondary)
                    
                    Picker(
                        selection: $pickerSelection,
                        label: Text("Segmented picker"),
                        content: {
                            Text("\(truncateNumberIfNeeded(number: user.publicRepos ?? 0)) Repos")
                                .tag(1)
                            Text("\(truncateNumberIfNeeded(number: user.followers ?? 0)) Followers")
                                .tag(2)
                            Text("\(truncateNumberIfNeeded(number: user.following ?? 0)) Following")
                                .tag(3)
                        }
                    )
                    .pickerStyle(SegmentedPickerStyle())
                    
                    switch pickerSelection {
                    case 1:
                        repos
                            .padding(-16)
                    case 2:
                        followers
                            .padding(-16)
                    case 3:
                        following
                            .padding(-16)
                    default:
                        EmptyView()
                    }
                    Spacer()
                }
                .padding(16)
                .navigationTitle("Profile")
            //}
            }
        .task {
            do {
                user = try await getUser(login: user.login)
            } catch GHError.invalidURL {
                print("Error: Invalid URL.")
            } catch GHError.invalidResponse {
                print("Error: Invalid Response.")
            } catch GHError.invalidData {
                print("Error: Invalid Data.")
            } catch {
                print("Unknown Error.")
            }
        }
    }
    
    func truncateNumberIfNeeded(number: Int) -> String {
        if number >= 10000 && number < 1000000 {
            return String(number / 1000) + "k"
        } else if number >= 1000000 {
            return String(number / 1000000) + "M"
        } else {
            return String(number)
        }
    }
}

extension ProfileView {
    
    var repos: some View {
        List {
//            if reposList.isEmpty {
//                Text("Loading...")
//            } else {
                ForEach(reposList, id: \.self) { repo in
                    NavigationLink(destination: RepoView(repo: repo)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(repo.name)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Text(repo.description ?? "")
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
//            }
        }
        .onAppear {
            getRepos(for: user.login, page: 1) { repos, errorMessage in
                guard let repos = repos else {
                    print("Error:", errorMessage ?? "Unknown error")
                    return
                }
                self.reposList = repos
            }
        }
    }
    
    var followers: some View {
        List {
            ForEach(followersList, id: \.self) { follower in
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
            }
        }
        .onAppear {
            getFollowers(for: user.login, page: 1) { followers, errorMessage in
                guard let followers = followers else {
                    print("Error:", errorMessage ?? "Unknown error")
                    return
                }
                self.followersList = followers
            }
        }
    }
    
    var following: some View {
        List {
            ForEach(followingList, id: \.self) { follower in
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
            }
        }
        .onAppear {
            getFollowing(for: user.login, page: 1) { followers, errorMessage in
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
