//
//  GameModel.swift
//  submission-ios-rawg
//
//  Created by Muhammad Hilmy Fauzi on 12/07/20.
//  Copyright © 2020 Muhammad Hilmy Fauzi. All rights reserved.
//

import Foundation

struct GameModels: Codable {
    let results: [GameModel]
}

struct GameModel: Codable {
    let id: Int
    let name: String?
    let released: String?
    let background_image: String?
    let rating: Double
    let rating_top: Double
    let ratings_count: Int
    let playtime: Int
    let reviews_count: Int
    let ratings: [Rating]
    let platforms: [Platforms]
    let genres: [Genre]
    let metacritic: Int?
}

struct Rating: Codable {
    let title: String
}

struct Platforms: Codable {
    let platform: Platform
}

struct Platform: Codable {
    let name: String
}

struct Genre: Codable {
    let name: String
}
