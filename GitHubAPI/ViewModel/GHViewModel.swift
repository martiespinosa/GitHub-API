//
//  GitHubViewModel.swift
//  GitHubAPI
//
//  Created by Martí Espinosa Farran on 26/3/24.
//

import Foundation

func getUser() async throws -> GHUser {
    let endpoint = "https://api.github.com/users/midudev"
    
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
    print(response)
    
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

func getAllGitHubFollowers() async throws -> [GHUser] {
    var allFollowers: [GHUser] = []
    var page = 1
    
    while true {
        let endpoint = "https://api.github.com/users/github/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            throw GHError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("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", forHTTPHeaderField: "Authorization") // Reemplaza YOUR_ACCESS_TOKEN con tu token de acceso
        
        let (data, response) = try await URLSession.shared.data(for: request)
        print(response)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw GHError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let followers = try decoder.decode([GHUser].self, from: data)
            
            // Si no hay seguidores en esta página, terminamos el bucle
            if followers.isEmpty {
                break
            }
            
            // Agregar los seguidores de esta página al array completo
            allFollowers.append(contentsOf: followers)
            
            // Incrementar el número de página para la siguiente iteración
            page += 1
        } catch {
            throw GHError.invalidData
        }
    }
    
    return allFollowers
}
