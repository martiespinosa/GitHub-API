//
//  RepoModel.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 7/4/24.
//

import Foundation

struct Repo: Codable, Hashable {
    let owner: GHUser
    let name: String
    let description: String?
    let htmlUrl: String?
    let language: String?
    //let languages: [Language]
}
