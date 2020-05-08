//
//  weatherTableViewCell.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class weatherTableViewCell: UITableViewCell {

    @IBOutlet weak var tempMinimum: UILabel!
    @IBOutlet weak var tempMaximum: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var dayNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
