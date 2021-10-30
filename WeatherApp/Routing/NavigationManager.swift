//
//  NavigationControllerRouter.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import UIKit

final class NavigationManager {
    let navigationController: UINavigationController
    let factory: ViewControllerFactory
    
    init(_ navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func startNavigationFlow() {
        push(factory.homePageViewController())
    }
    
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func present(_ viewController: UIViewController) {
        navigationController.topViewController?.present(viewController, animated: true)
    }
    
    func showToastMessageView(with message: String) {
        navigationController.topViewController?.showToastMessageView(with: message, font: .systemFont(ofSize: 14))
    }
}
