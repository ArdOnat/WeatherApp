//
//  NavigationRouter.swift
//  WeatherApp
//
//  Created by Arda Onat on 4.10.2021.
//

import UIKit

protocol NavigationRouter: AnyObject {
    var navigationController: UINavigationController { get }
    var factory: ViewControllerFactory { get }
    
    func startNavigationFlow()
    func push(_ viewController: UIViewController)
    func showToastMessageView(with message: String)
}

extension NavigationRouter {
    func push(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showToastMessageView(with message: String) {
        navigationController.topViewController?.showToastMessageView(with: message, font: .systemFont(ofSize: 14))
    }
}
