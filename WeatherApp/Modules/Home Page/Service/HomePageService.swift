//
//  HomePageService.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import CoreModule

protocol HomePageServiceProtocol {
    var homeApi: HomeApi { get }
    var output: HomePageServiceOutputProtocol? { get set }
    
    func fetchWeatherData(cityName: String)
    func fetchWeatherData(latitude: Double, longitude: Double)
}

protocol HomeApi {
    func fetchWeatherDataWithCityName(cityName: String, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> Void)
    func fetchWeatherDataWithCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> Void)
}

protocol HomePageServiceOutputProtocol {
    func onFetchWeatherInformationSuccess(response: WeatherInformationResponseModel)
    func onFetchWeatherInformationFailure(error: Error)
}


final class HomePageService: HomePageServiceProtocol {
    
    let homeApi: HomeApi
    var output: HomePageServiceOutputProtocol?
    
    init(homeApi: HomeApi) {
        self.homeApi = homeApi
    }
    
    func fetchWeatherData(cityName: String) {
        homeApi.fetchWeatherDataWithCityName(cityName: cityName) { result in
            switch result {
            case .success(let response):
                self.output?.onFetchWeatherInformationSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchWeatherInformationFailure(error: error)
            }
        }
    }

    func fetchWeatherData(latitude: Double, longitude: Double) {
        homeApi.fetchWeatherDataWithCoordinates(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let response):
                self.output?.onFetchWeatherInformationSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchWeatherInformationFailure(error: error)
            }
        }
    }
}

extension WeakRef: HomePageServiceOutputProtocol where T: HomePageServiceOutputProtocol {
    
    func onFetchWeatherInformationSuccess(response: WeatherInformationResponseModel) {
        object?.onFetchWeatherInformationSuccess(response: response)
    }
    
    func onFetchWeatherInformationFailure(error: Error) {
        object?.onFetchWeatherInformationFailure(error: error)
    }
}
