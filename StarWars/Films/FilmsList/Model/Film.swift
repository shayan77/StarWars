//
//  Film.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation

struct Film: Codable {
    let title: String?
    let episode_id: Int?
    let opening_crawl: String?
    let director: String?
    let producer: String?
    let release_date: String?
    let characters: [String]?
    let planets: [String]?
    let starships: [String]?
    let vehicles: [String]?
    let species: [String]?
    let created: String?
    let edited: String?
    let url: String?
}
