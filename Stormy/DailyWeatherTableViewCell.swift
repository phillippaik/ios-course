//
//  DailyWeatherTableViewCell.swift
//  Stormy
//
//  Created by Phillip Paik on 3/1/16.
//  Copyright © 2016 Phillip Paik. All rights reserved.
//

import UIKit

class DailyWeatherTableViewCell: UITableViewCell {
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
