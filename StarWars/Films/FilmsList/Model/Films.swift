//
//  Films.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation

struct Films: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [Film]?
}
