//
//  HomePagePresenter.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import Foundation

protocol arda: muhammed {
    
}

protocol muhammed {
    
}


protocol HomePagePresenterProtocol: AnyObject {
    var view: HomePageViewProtocol? { get set }
    var interactor: HomePageInteractorProtocol { get }
    var wireframe: HomePageWireframeProtocol { get }
    
    var weatherInformationList: [[CountryWeatherInformationModel]] { get set }
    var cityName: String { get set }
    
    func viewDidLoad()
    func didUpdateLocations(latitude: Double, longitude: Double)
    func didSearchBarSearchButtonClicked(cityName: String)
    func scrollViewDidScroll()
}
    
final class HomePagePresenter: HomePagePresenterProtocol {

    // MARK: Internal properties
    var view: HomePageViewProtocol?
    let interactor: HomePageInteractorProtocol
    let wireframe: HomePageWireframeProtocol
    var weatherData: WeatherInformationResponseModel?
    
    var weatherInformationList: [[CountryWeatherInformationModel]] = []
    var cityName: String = ""

    // MARK: Initializer
    init(interactor: HomePageInteractorProtocol,
         wireframe: HomePageWireframeProtocol) {
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    // MARK: Life Cycle
    func viewDidLoad() {
        DispatchQueue.main.async {
            self.view?.changeViewState(.loading)
            self.view?.setupSearchBar()
            self.view?.setupTableView()
            self.view?.setupGeoLocation()
            self.view?.setupActivityIndicator()
            self.view?.showActivityIndicator(true)
        }
    }
    
    func didUpdateLocations(latitude: Double, longitude: Double) {
        interactor.fetchWeatherData(latitude: latitude, longitude: longitude)
    }
    
    func didSearchBarSearchButtonClicked(cityName: String) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.loading)
            self.view?.endSearchBarEditing()
            self.view?.showActivityIndicator(true)
        }
        
        interactor.fetchWeatherData(with: cityName)
    }
    
    func scrollViewDidScroll() {
        DispatchQueue.main.async {
            self.view?.endSearchBarEditing()
        }
    }
}

extension HomePagePresenter: HomePageInteractorOutputProtocol {
    
    func onFetchWeatherInformationSuccess(weatherInformationList: [[CountryWeatherInformationModel]], cityName: String) {
        self.weatherInformationList = weatherInformationList
        self.cityName = cityName
        
        DispatchQueue.main.async {
            self.view?.changeViewState(.success)
            self.view?.showActivityIndicator(false)
        }
    }
    
    func onFetchWeatherInformationFailure(errorMessage: String) {
        DispatchQueue.main.async {
            self.view?.changeViewState(.failure(errorMessage: errorMessage))
            self.view?.showActivityIndicator(false)
        }
    }
}
