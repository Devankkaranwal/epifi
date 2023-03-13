//
//  DataTableViewCell.swift
//  epiFiProject
//
//  Created by Devank Karanwal on 12/03/23.
//

import UIKit

class DataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblWeatherIcon: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
