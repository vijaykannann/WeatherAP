//
//  CityListTableViewCell.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class CityListTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
