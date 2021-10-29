//
//  ApiClient+HomeApi.swift
//  WeatherApp
//
//  Created by Arda Onat on 15.09.2021.
//

import ApiClient
import class CoreModule.ApiEnvironment
import enum CoreModule.NetworkError
import HomeModule

extension ApiClient: HomeApi {
    public func fetchWeatherDataWithCityName(cityName: String, completion: @escaping (Result<WeatherInformationResponse, CoreModule.NetworkError>) -> Void) {
        let request = HomePageRequest(request: HomePageRequest.Request.fetchWeatherDataWithCityName(cityName: cityName), apiEnvironment: CoreModule.ApiEnvironment(environmentType: WeatherForecastNetworkEnvironment.prod))
        self.request(request, completion: completion)
    }
    
    public func fetchWeatherDataWithCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherInformationResponse, CoreModule.NetworkError>) -> Void) {
        let request = HomePageRequest(request: HomePageRequest.Request.fetchWeatherDataWithCoordinates(latitude: latitude, longitude: longitude), apiEnvironment: CoreModule.ApiEnvironment(environmentType: WeatherForecastNetworkEnvironment.prod))
        self.request(request, completion: completion)
    }
}
