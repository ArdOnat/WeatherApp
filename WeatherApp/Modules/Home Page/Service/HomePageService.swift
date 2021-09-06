//
//  HomePageService.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import NetworkModule

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

protocol HomePageServiceProtocol {
    func fetchWeatherData(cityName: String, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> ())
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> ())
}

final class HomePageService: HomePageServiceProtocol {
    
    init (networkLayer: NetworkLayer) {
        self.networkLayer = networkLayer
    }
    
    var networkLayer: NetworkLayer?
    
    func fetchWeatherData(cityName: String, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> ()) {
        networkLayer?.request(HomePageRequest.fetchWeatherDataWithCityName(cityName: cityName), completion: completion)
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> ()) {
        networkLayer?.request(HomePageRequest.fetchWeatherDataWithCoordinates(latitude: latitude, longitude: longitude), completion: completion)
    }
}
