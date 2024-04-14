//
//  RepoView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 7/4/24.
//

import SwiftUI

struct RepoView: View {
    
    // MARK: - PROPERTIES
    
    @State var repo: Repo
    
    // MARK: - BODY
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(alignment: .leading, spacing: 25) {
                    ownerUser
                    repoMainInfo
                    repoDescription
                    if let url = URL(string: repo.htmlUrl ?? "") {
                        Link("View more", destination: url)
                            .font(.headline)
                    }
                }
                .padding(16)
                Spacer()
            }
            .navigationTitle("Repo")
        }
    }
}

// MARK: - COMPONENTS

extension RepoView {
    
    private var ownerUser: some View {
        HStack {
            AsyncImage(
                url: URL(string: repo.owner.avatarUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .foregroundStyle(.secondary)
                }
                .frame(width: 25, height: 25)
            
            Text("@" + repo.owner.login)
                .foregroundStyle(.secondary)
            Spacer()
        }
    }
    
    private var repoMainInfo: some View {
        VStack(alignment: .leading) {
            Text(repo.name)
                .font(.title)
                .bold()
            Text(repo.language ?? "")
                .font(.title3)
                .foregroundStyle(Color.accentColor)
        }
    }
    
    private var repoDescription: some View {
        Text(repo.description ?? "")
            .foregroundStyle(.secondary)
    }
    
}

//#Preview {
//    RepoView()
//}
