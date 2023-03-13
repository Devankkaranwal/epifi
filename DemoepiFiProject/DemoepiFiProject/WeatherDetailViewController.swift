//
//  WeatherDetailViewController.swift
//  epiFiProject
//
//  Created by Devank Karanwal on 12/03/23.
//

import UIKit


class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
  

           override func viewDidLoad() {
            super.viewDidLoad()
               self.timeLabel.text = UserDefaults.standard.string(forKey: "time")
               self.weatherTextLabel.text = UserDefaults.standard.string(forKey: "weatherText")
               self.windSpeedLabel.text = UserDefaults.standard.string(forKey: "weatherIcon")
               self.temperatureLabel.text = UserDefaults.standard.string(forKey: "metrix")

        }
    
}
