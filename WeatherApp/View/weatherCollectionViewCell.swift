//
//  weatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by VJ's iMAC on 05/05/20.
//  Copyright © 2020 Deuglo. All rights reserved.
//

import UIKit

class weatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImg: UIImageView!
    @IBOutlet weak var timelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
