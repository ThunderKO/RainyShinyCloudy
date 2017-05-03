//
//  WeatherCell.swift
//  RainyShinyCloudy
//
//  Created by KO TING on 2/5/2017.
//  Copyright © 2017年 EdUHK. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var lbDay: UILabel!
    @IBOutlet weak var lbWeatherType: UILabel!
    @IBOutlet weak var lbHighTemp: UILabel!
    @IBOutlet weak var lbLowTemp: UILabel!
    
    func configureCell(forecast: Forecast) {
        lbLowTemp.text = "\(forecast.lowTemp)"
        lbHighTemp.text = "\(forecast.highTemp)"
        lbWeatherType.text = forecast._weatherType
        lbDay.text = forecast.date
        weatherIcon.image = UIImage(named: forecast.weatherType)
    }



}
