//
//  iOSUIKitViewControllerFactory.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import UIKit

// Import UI Modules
import CoreModule
import HomeModule

final class ViewFactory: ViewControllerFactory {

    private let apiClient: ApiClient
    weak var navigationDelegate: NavigationRouter?
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func homePageViewController() -> UIViewController {
        guard let homePage = homePage() else { return UIViewController() }
        return homePage
    }
    
    private func homePage() -> HomeViewController? {
        guard let homeApi = apiClient as? HomeApi, let navigationDelegate = navigationDelegate as? HomeNavigation else { return nil }
        return HomePageModuleBuilder.generate(homeApi: homeApi, homeNavigation: navigationDelegate)
    }
}
