//
//  ContentView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import SwiftUI

struct TabsView: View {
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "house.fill")
//                    Text("Inicio")
//                }
//                .tag(0)
            
//            ProfileView()
//                .tabItem {
//                    Image(systemName: "square.grid.2x2.fill")
//                    Text("Explorar")
//                }
//                .tag(1)
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Buscar")
                }
                .tag(2)
        }
    }
}

#Preview {
    TabsView()
}
