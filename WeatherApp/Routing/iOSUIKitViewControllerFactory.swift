//
//  iOSUIKitViewControllerFactory.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import Foundation
import UIKit

// Import UI Modules
import HomeModule

// Composition Root
final class iOSUIKitViewControllerFactory: ViewControllerFactory {
    
    typealias ApiClientHelper = HomeApi
    typealias NavigationHelper = (HomeNavigation & AnyObject)
    
    private let apiClient: ApiClientHelper
    weak var navigationDelegate: NavigationHelper!
    
    init(apiClient: ApiClientHelper) {
        self.apiClient = apiClient
    }
    
    func homePageViewController() -> UIViewController {
        return homePage()
    }
    
    private func homePage() -> HomeViewController {
        return HomePageModuleBuilder.generate(homeApi: apiClient, homeNavigation: navigationDelegate)
    }
}
