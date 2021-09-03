//
//  HomePageRepository.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol HomePageRepositoryProtocol {
    var output: HomePageRepositoryOutputProtocol? { get set }
    
    func fetchWeatherData(cityName: String)
    func fetchWeatherData(latitude: Double, longitude: Double)
}

protocol HomePageRepositoryOutputProtocol {
    func onFetchWeatherInformationSuccess(response: WeatherInformationResponseModel)
    func onFetchWeatherInformationFailure(error: Error)
}

final class HomePageRepository: HomePageRepositoryProtocol {
    
    // MARK: Private properties
    private let service: HomePageServiceProtocol
    
    // MARK: Public properties
    var output: HomePageRepositoryOutputProtocol?
    
    // MARK: Initializers
    init(service: HomePageServiceProtocol) {
        self.service = service
    }
    
    func fetchWeatherData(cityName: String) {
        service.fetchWeatherData(cityName: cityName) { result in 
            switch result {
            case .success(let response):
                self.output?.onFetchWeatherInformationSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchWeatherInformationFailure(error: error)
            }
        }
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        service.fetchWeatherData(latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let response):
                self.output?.onFetchWeatherInformationSuccess(response: response)
            case .failure(let error):
                self.output?.onFetchWeatherInformationFailure(error: error)
            }
        }
    }
}

extension WeakRef: HomePageRepositoryOutputProtocol where T: HomePageRepositoryOutputProtocol {
    
    func onFetchWeatherInformationSuccess(response: WeatherInformationResponseModel) {
        object?.onFetchWeatherInformationSuccess(response: response)
    }
    
    func onFetchWeatherInformationFailure(error: Error) {
        object?.onFetchWeatherInformationFailure(error: error)
    }
}
