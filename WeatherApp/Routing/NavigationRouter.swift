//
//  NavigationRouter.swift
//  WeatherApp
//
//  Created by Arda Onat on 4.10.2021.
//

import UIKit
import Foundation

protocol NavigationRouter: AnyObject {
    var navigationController: UINavigationController { get }
    var factory: ViewControllerFactory { get }
    
    func startNavigation()
    
    func push(_ viewController: UIViewController)
}
