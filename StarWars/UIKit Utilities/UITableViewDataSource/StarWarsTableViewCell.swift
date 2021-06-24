//
//  StarWarsTableViewCell.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit

public protocol StarWarsTableViewCell: UITableViewCell {
    
    associatedtype CellViewModel
    
    func configureCellWith(_ item: CellViewModel)
    
}
