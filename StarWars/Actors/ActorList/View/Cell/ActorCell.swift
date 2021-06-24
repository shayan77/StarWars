//
//  ActorCell.swift
//  StarWars
//
//  Created by Shayan Mehranpoor on 6/24/21.
//

import UIKit

class ActorCell: UITableViewCell {
    
    @IBOutlet var cellView: UIView!
    @IBOutlet var actorNameLbl: UILabel!
    @IBOutlet var sexLbl: UILabel!
    @IBOutlet var birthLbl: UILabel!
    @IBOutlet var heightLbl: UILabel!
    @IBOutlet var weightLbl: UILabel!
    @IBOutlet var skinLbl: UILabel!
    @IBOutlet var hairLbl: UILabel!
    @IBOutlet var rateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius  = 15.0
        cellView.layer.borderColor = UIColor.opaqueSeparator.cgColor
    }
}

extension ActorCell: StarWarsTableViewCell {
    func configureCellWith(_ item: Actor) {
        actorNameLbl.text = item.name ?? ""
        sexLbl.text = item.gender ?? ""
        birthLbl.text = item.birth_year ?? ""
        heightLbl.text = "\(item.height ?? "") CM"
        weightLbl.text = "\(item.mass ?? "") Kg"
        skinLbl.text = "\(item.skin_color ?? "") skin color"
        hairLbl.text = "\(item.hair_color ?? "") hair color"
        if let rate = item.rate {
            rateLbl.text = "\(rate)"
        } else {
            rateLbl.text = "Unrated"
        }
    }
}
