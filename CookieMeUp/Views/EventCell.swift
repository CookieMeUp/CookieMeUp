//
//  EventCell.swift
//  CookieMeUp
//
//  Created by Daniel Calderon on 3/27/18.
//  Copyright © 2018 Daniel Calderon. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
