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
    weak var navigationManager: NavigationManager?
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func homePageViewController() -> UIViewController {
        guard let homePage = homePage() else { return UIViewController() }
        return homePage
    }
    
    private func homePage() -> HomeViewController? {
        guard let homeApi = networkClient as? HomeApi, let navigationManager = navigationManager else { return nil }
        return HomePageModuleBuilder.generate(homeApi: homeApi, homeNavigationHandler: navigationManager, viewOperationHandler: navigationManager)
    }
}
