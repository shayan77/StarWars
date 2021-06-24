//
//  Actor.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import Foundation

class Actor: Codable {
    let name: String?
    let height: String?
    let mass: String?
    let hair_color: String?
    let skin_color: String?
    let eye_color: String?
    let birth_year: String?
    let gender: String?
    var rate: Int? = 0
}
