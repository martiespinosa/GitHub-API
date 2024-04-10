//
//  ContentView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import SwiftUI

struct TabsView: View {
    
    // MARK: - PROPERTIES
    
    @State var selectedTab: Int = 0
    
    // MARK: BODY
    
    var body: some View {
        TabView(selection: $selectedTab) {
            profileView
            
            searchView
        }
    }
}

// MARK: - COMPONENTS

extension TabsView {
    
    var profileView: some View {
        ProfileView(user: GHUser(login: "martiespinosa", name: "Marti", avatarUrl: "", bio: "", publicRepos: 0, followers: 0, following: 0))
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }
            .tag(0)
    }
    
    var searchView: some View {
        SearchView()
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Search")
            }
            .tag(1)
    }
    
}

#Preview {
    TabsView()
}
