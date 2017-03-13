//
//  DetailTableViewCell.swift
//  CRRD
//
//  Created by Fahmy Mohammed.
//  Copyright © 2017 CS467 W17 - Team Reticulum. All rights reserved.
//

import UIKit

//Custom cell in the table views used in BusinessDetail, About, and Contact View Controllers
class DetailTableViewCell: UITableViewCell {

    @IBOutlet var businessCellImage: UIImageView!
    @IBOutlet var businessCellLabelValue: UILabel!
    @IBOutlet var contactCellImage: UIImageView!
    @IBOutlet var contactCellLabelValue: UILabel!
    @IBOutlet var aboutCellImage: UIImageView!
    @IBOutlet var aboutCellLabelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
