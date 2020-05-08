//
//  weatherDetailsTableViewCell.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class weatherDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLeft: UILabel!
    @IBOutlet weak var titleRight: UILabel!
    @IBOutlet weak var leftValue: UILabel!
    @IBOutlet weak var rightValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
