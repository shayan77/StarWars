//
//  FilmCell.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit

class FilmCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var nameLbl: UILabel!
    @IBOutlet var directorLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius  = 15.0
        cellView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
}

extension FilmCell: StarWarsTableViewCell {
    func configureCellWith(_ item: Film) {
        nameLbl.text = item.title ?? ""
        directorLbl.text = item.director ?? ""
        dateLbl.text = "Release Date: \(item.release_date ?? "")"
    }
}
