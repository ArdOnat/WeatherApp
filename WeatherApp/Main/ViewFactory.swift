//
//  iOSUIKitViewControllerFactory.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import UIKit

// Import UI Modules
import HomeModule

// Composition Root
final class ViewFactory: ViewControllerFactory {

    private let apiClient: ApiClientType
    weak var navigationDelegate: NavigationRouter?
    
    init(apiClient: ApiClientType) {
        self.apiClient = apiClient
    }
    
    func homePageViewController() -> UIViewController {
        guard let homePage = homePage() else { return UIViewController() }
        return homePage
    }
    
    private func homePage() -> HomeViewController? {
        guard let navigationDelegate = navigationDelegate as? HomeNavigation else { return nil }
        return HomePageModuleBuilder.generate(homeApi: apiClient, homeNavigation: navigationDelegate)
    }
}
