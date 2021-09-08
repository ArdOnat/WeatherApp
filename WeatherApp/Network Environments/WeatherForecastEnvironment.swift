//
//  WeatherForecastEnvironment.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import CoreModule

enum WeatherForecastNetworkEnvironment: NetworkEnvironment {
    case prod
    
    var baseURL: String {
        switch self {
        case .prod: return "https://api.openweathermap.org/data/2.5/"
        }
    }
}
