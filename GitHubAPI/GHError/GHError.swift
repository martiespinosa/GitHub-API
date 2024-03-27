//
//  GHError.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import Foundation

enum GHError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
