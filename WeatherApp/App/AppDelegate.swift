//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import UIKit
import CoreModule
import ApiClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard window != nil else { return  false }
        
        // MARK: Setup ApiClient
        ApiClient.setup(ApiClient.DefaultParameterConfig(defaultURLParameters: ["appid": "4325b9f55f7d320b4237e7f840be9567"]))
        
        let homeViewController = HomePageModuleBuilder.generate(homeApi: ApiClient.shared)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension ApiClient: HomeApi {
    func fetchWeatherDataWithCityName(cityName: String, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> Void) {
        self.request(HomePageRequest.fetchWeatherDataWithCityName(cityName: cityName), completion: completion)
    }
    
    func fetchWeatherDataWithCoordinates(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherInformationResponseModel, NetworkError>) -> Void) {
        self.request(HomePageRequest.fetchWeatherDataWithCoordinates(latitude: latitude, longitude: longitude), completion: completion)
    }
}

