//
//  GitHubViewModel.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import Foundation

func getUser(login: String) async throws -> GHUser {
    let endpoint = "https://api.github.com/users/\(login)"
    
    guard let url = URL(string: endpoint) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(GHUser.self, from: data)
    } catch {
        throw GHError.invalidData
    }
}

func get100Users() async throws -> [GHUser] {
    let endpoint = "https://api.github.com/users?per_page=100"
    
    guard let url = URL(string: endpoint) else {
        throw GHError.invalidURL
    }
    
    let (data, response) = try await URLSession.shared.data(from: url)
    
    guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
        throw GHError.invalidResponse
    }
    
    do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode([GHUser].self, from: data)
    } catch {
        throw GHError.invalidData
    }
}

func getFollowers(for login: String, page: Int, completed: @escaping ([GHUser]?, String?) -> Void) {
    let endpoint = "https://api.github.com/users/\(login)/followers?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
        completed(nil, "Invalid Request")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let _ = error {
            completed(nil, "Unable to complete the request, check internet connection")
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completed(nil, "Invalid Response")
            return
        }
        guard let data = data else {
            completed(nil, "Invalid Data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([GHUser].self, from: data)
            completed(followers, nil)
        } catch {
            completed(nil, "Unknown Error")
        }
                
    }
    
    task.resume()
}

func getFollowing(for login: String, page: Int, completed: @escaping ([GHUser]?, String?) -> Void) {
    let endpoint = "https://api.github.com/users/\(login)/following?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
        completed(nil, "Invalid Request")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let _ = error {
            completed(nil, "Unable to complete the request, check internet connection")
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completed(nil, "Invalid Response")
            return
        }
        guard let data = data else {
            completed(nil, "Invalid Data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([GHUser].self, from: data)
            completed(followers, nil)
        } catch {
            completed(nil, "Unknown Error")
        }
                
    }
    
    task.resume()
}

func getRepos(for login: String, page: Int, completed: @escaping ([Repo]?, String?) -> Void) {
    let endpoint = "https://api.github.com/users/\(login)/repos?per_page=100&page=\(page)"
    
    guard let url = URL(string: endpoint) else {
        completed(nil, "Invalid Request")
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let _ = error {
            completed(nil, "Unable to complete the request, check internet connection")
        }
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            completed(nil, "Invalid Response")
            return
        }
        guard let data = data else {
            completed(nil, "Invalid Data")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let repos = try decoder.decode([Repo].self, from: data)
            completed(repos, nil)
        } catch {
            completed(nil, "Unknown Error")
        }
                
    }
    
    task.resume()
}
