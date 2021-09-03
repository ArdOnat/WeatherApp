//
//  WeatherInformationResponseModel.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import Foundation

struct WeatherInformationResponseModel: Codable {
    let list: [CountryWeatherInformationModel]
    let city: CityInformationModel
}

struct CountryWeatherInformationModel: Codable {
    let main: MainformationModel
    let weather: [WeatherInformationModel]
    let dt_txt: String
}

struct MainformationModel: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let humidity: Double
}

struct WeatherInformationModel: Codable {
    let main: String
    let icon: String
}

struct CityInformationModel: Codable {
    let name: String
}
