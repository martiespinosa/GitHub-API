//
//  SearchView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 27/3/24.
//

import SwiftUI

struct SearchView: View {
    
    @State private var users: [GHUser] = []
    @State private var searchTerm: String = ""
    
    var filteredUsers: [GHUser] {
        guard !searchTerm.isEmpty else { return users }
        return users.filter { $0.login.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if filteredUsers.isEmpty {
                    ContentUnavailableView.search(text: searchTerm)
                } else {
                    LazyVStack(alignment: .leading) {
                        ForEach(filteredUsers, id: \.self) { user in
                            HStack {
                                AsyncImage(
                                    url: URL(string: user.avatarUrl)) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .clipShape(Circle())
                                    } placeholder: {
                                        Circle()
                                            .foregroundStyle(.secondary)
                                    }
                                    .frame(width: 50, height: 50)
                                
                                Text(user.login)
                                    .font(.headline)
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            Divider()
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $searchTerm, prompt: "Search Users")
            .autocorrectionDisabled()
            .task {
                do {
                    users = try await get100Users()
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
    }
}
 
#Preview {
    SearchView()
}
