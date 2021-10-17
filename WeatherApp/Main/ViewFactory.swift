//
//  iOSUIKitViewControllerFactory.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import UIKit
import CoreModule

// Import UI Modules
import HomeModule

final class ViewFactory: ViewControllerFactory {

    private let networkClient: NetworkClient
    weak var navigationDelegate: NavigationRouter?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func homePageViewController() -> UIViewController {
        guard let homePage = homePage() else { return UIViewController() }
        return homePage
    }
    
    private func homePage() -> HomeViewController? {
        guard let homeApi = networkClient as? HomeApi, let navigationDelegate = navigationDelegate as? HomeNavigation else { return nil }
        return HomePageModuleBuilder.generate(homeApi: homeApi, homeNavigation: navigationDelegate)
    }
}
