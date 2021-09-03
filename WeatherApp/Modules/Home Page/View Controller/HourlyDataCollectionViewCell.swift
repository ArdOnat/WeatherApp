//
//  HourlyDataCollectionViewCell.swift
//  WeatherApp
//
//  Created by Arda Onat on 21.08.2021.
//

import UIKit

class HourlyDataCollectionViewCell: UICollectionViewCell {

    static let ReuseIdentifier: String = "HourlyDataCollectionViewCell"
    
    @IBOutlet private weak var hourLabel: UILabel!
    @IBOutlet private weak var weatherSituationImageView: UIImageView!
    @IBOutlet private weak var lowTemperatureLabel: UILabel!
    @IBOutlet private weak var highTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(informationModel: CountryWeatherInformationModel) {
        if let clock = informationModel.dt_txt.split(separator: " ").last, let hour = clock.split(separator: ":").first {
            hourLabel.text = "\(hour)"
        }
        else {
            hourLabel.text = "?"
        }
        
        weatherSituationImageView.image = UIImage(named: informationModel.weather.first?.icon ?? "")
        lowTemperatureLabel.text = "\(informationModel.main.temp_min.rounded())"
        highTemperatureLabel.text = "\(informationModel.main.temp_max.rounded())"
    }
}
