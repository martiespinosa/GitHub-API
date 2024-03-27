//
//  UserModel.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import Foundation

struct GHUser: Codable, Hashable {
    let login: String
    let name: String?
    let avatarUrl: String
    let bio: String?
}
