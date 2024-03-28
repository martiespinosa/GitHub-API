//
//  ProfileView.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import SwiftUI

struct ProfileView: View {
    
    var user: GHUser
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                AsyncImage(
                    url: URL(string: user.avatarUrl)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .padding(.bottom, 10)
                    } placeholder: {
                        Circle()
                            .frame(width: 200, height: 200)
                            .foregroundStyle(.gray)
                            .shadow(radius: 10)
                            .padding(.bottom, 10)
                    }

                Text(user.name ?? "")
                    .font(.title)
                
                Text("@\(user.login)")
                    .font(.title3)
                
                Text(user.bio ?? "")
                    .foregroundStyle(.secondary)
                    .padding(.top, 20)
                Spacer()
            }
            .padding()
            .navigationTitle("Profile")
        }
//        .task {
//            do {
//                user = try await getUser()
//            } catch GHError.invalidURL {
//                print("Error: Invalid URL.")
//            } catch GHError.invalidResponse {
//                print("Error: Invalid Response.")
//            } catch GHError.invalidData {
//                print("Error: Invalid Data.")
//            } catch {
//                print("Unknown Error.")
//            }
//        }
    }
}

//#Preview {
//    ProfileView()
//}
