//
//  WeatherForecastEnvironment.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import NetworkModule

struct WeatherForecastApi: ApiEnvironment {
    var environmentType: NetworkEnvironment
    
    init(_ environmentType: NetworkEnvironment) {
        self.environmentType = environmentType
    }
}

enum WeatherForecastNetworkEnvironment: NetworkEnvironment {
    case prod
    
    var baseURL: String {
        switch self {
        case .prod: return "https://api.openweathermap.org/data/2.5/"
        }
    }
}
