//
//  SearchView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 27/3/24.
//

import SwiftUI

struct SearchView: View {
    
    // MARK: - PROPERTIES
    
//    @ObservedObject private var vm: GHViewModel
    @StateObject private var vm = GHViewModel()
    
    @State private var users: [GHUser] = []
    @State private var searchTerm: String = ""
    @State private var isLoading: Bool = true
    
    var filteredUsers: [GHUser] {
        return users.filter { $0.login.localizedCaseInsensitiveContains(searchTerm) }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationStack {
            List {
                if filteredUsers.isEmpty && !searchTerm.isEmpty {
                    ContentUnavailableView.search(text: searchTerm)
                } else {
                    usersList
                }
            }
            .redacted(reason: isLoading ? .placeholder : [])
            .navigationTitle("Search")
            .searchable(text: $searchTerm, prompt: "Search Users")
            .autocorrectionDisabled()
            .task {
                do {
                    users = try await vm.get100Users()
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
    }
}
 
// MARK: - COMPONENTS

extension SearchView {
    
    private var usersList: some View {
        ForEach(filteredUsers, id: \.self) { user in
            NavigationLink(destination: ProfileView(user: user)) {
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
            }
        }
    }
    
}


#Preview {
    SearchView()
}
