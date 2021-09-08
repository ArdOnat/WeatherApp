//
//  HomePageRequest.swift
//  WeatherApp
//
//  Created by Arda Onat on 6.09.2021.
//

import CoreModule

enum HomePageRequest: Request {
    
    case fetchWeatherDataWithCityName(cityName: String)
    case fetchWeatherDataWithCoordinates(latitude: Double, longitude: Double)
    
    var path: String {
        switch self {
        case .fetchWeatherDataWithCityName(_):
            return "forecast"
        case .fetchWeatherDataWithCoordinates(_, _):
            return "forecast"
        }
    }
    
    var apiEnvironment: ApiEnvironment {
        switch self {
        case .fetchWeatherDataWithCityName(_): return WeatherForecastApi(WeatherForecastNetworkEnvironment.prod)
        case .fetchWeatherDataWithCoordinates(_, _): return WeatherForecastApi(WeatherForecastNetworkEnvironment.prod)
        }
    }
    
    var httpMethod: HTTPMethods {
        return .get
    }
    
    var urlParameters: Parameters? {
        switch self {
        case .fetchWeatherDataWithCityName(let cityName):
            var urlParameters: Parameters = Parameters()
            urlParameters["q"] = cityName
            urlParameters["units"] = "metric"
            
            return urlParameters
        case .fetchWeatherDataWithCoordinates(let latitude, let longitude):
            var urlParameters: Parameters = Parameters()
            urlParameters["lat"] = "\(latitude)"
            urlParameters["lon"] = "\(longitude)"
            urlParameters["units"] = "metric"
            
            return urlParameters
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
    
    var httpHeaders: HTTPHeaders? {
        return nil
    }
}
