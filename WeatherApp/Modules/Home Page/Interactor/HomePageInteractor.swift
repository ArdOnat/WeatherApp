//
//  HomePageInteractor.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

protocol HomePageInteractorProtocol {
    var service: HomePageServiceProtocol { get }
    var output: HomePageInteractorOutputProtocol? { get set }
    
    func fetchWeatherData(with cityName: String)
    func fetchWeatherData(latitude: Double, longitude: Double)
}

protocol HomePageInteractorOutputProtocol {
    func onFetchWeatherInformationSuccess(weatherInformationList: [[CountryWeatherInformationModel]], cityName: String)
    func onFetchWeatherInformationFailure(errorMessage: String)
}

final class HomePageInteractor: HomePageInteractorProtocol {
    
    let service: HomePageServiceProtocol
    var output: HomePageInteractorOutputProtocol?
    
    // MARK: Initializers
    init(service: HomePageServiceProtocol) {
        self.service = service
    }
    
    func fetchWeatherData(with cityName: String) {
        service.fetchWeatherData(cityName: cityName)
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double) {
        service.fetchWeatherData(latitude: latitude, longitude: longitude)
    }
    
    /// Splits weather information data into different days.
    /// - Parameter weatherInformationModelArray: Information array to be split.
    /// - Returns: Array of information model arrays.
    private func prepareWeatherInformationData(weatherInformationModelArray:[CountryWeatherInformationModel]) -> [[CountryWeatherInformationModel]]  {
        var splittedItems: [[CountryWeatherInformationModel]] = []
        var days: [Int] = []
        
        for weatherInformationModel in weatherInformationModelArray {
            guard let day = weatherInformationModel.dt_txt.dayFromString() else { return [] }
            
            if !days.contains(day) { days.append(day) }
        }
        
        for i in 0..<days.count {
            let filteredData = weatherInformationModelArray.filter {
                guard let day = $0.dt_txt.dayFromString() else { return false }
                
                return days[i] == day
            }
            splittedItems.append(filteredData)
        }
        return splittedItems
    }
}

extension HomePageInteractor: HomePageServiceOutputProtocol {
    
    func onFetchWeatherInformationSuccess(response: WeatherInformationResponseModel) {
        output?.onFetchWeatherInformationSuccess(weatherInformationList: prepareWeatherInformationData(weatherInformationModelArray: response.list), cityName: response.city.name)
    }
    
    func onFetchWeatherInformationFailure(error: Error) {
        output?.onFetchWeatherInformationFailure(errorMessage: error.localizedDescription)
    }
}

extension WeakRef: HomePageInteractorOutputProtocol where T: HomePageInteractorOutputProtocol {
    
    func onFetchWeatherInformationSuccess(weatherInformationList: [[CountryWeatherInformationModel]], cityName: String) {
        object?.onFetchWeatherInformationSuccess(weatherInformationList: weatherInformationList, cityName: cityName)
    }
    
    func onFetchWeatherInformationFailure(errorMessage: String) {
        object?.onFetchWeatherInformationFailure(errorMessage: errorMessage)
    }
}
