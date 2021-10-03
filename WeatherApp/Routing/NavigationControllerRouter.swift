//
//  NavigationControllerRouter.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import UIKit

final class NavigationControllerRouter {
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func startNavigation() {
        push(factory.homePageViewController())
    }
    
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
}
