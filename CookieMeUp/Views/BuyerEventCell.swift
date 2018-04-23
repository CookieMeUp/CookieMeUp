//
//  BuyerEventCell.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/30/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit

class BuyerEventCell: UITableViewCell {
 
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var streetAdressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
