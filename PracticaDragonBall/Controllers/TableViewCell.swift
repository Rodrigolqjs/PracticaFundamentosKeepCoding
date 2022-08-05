//
//  TableViewCell.swift
//  DragonBall-Practica
//
//  Created by Rodrigo Latorre on 14/07/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var heroDescription: UILabel!
    
    func set(model: Hero) {
        self.heroName.text = model.name
        self.heroDescription.text = model.description
        self.heroImage.setImage(url: model.photo)
    }
    
    func set(model: Transformations) {
        self.heroName.text = model.name
        self.heroDescription.text = model.description
        self.heroImage.setImage(url: model.photo)
    }
}
