//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard window != nil else { return  false }
        let homeViewController = HomePageModuleBuilder.generate(networkLayer: URLSessionNetworkLayer(defaultURLParameters: ["appid": "4325b9f55f7d320b4237e7f840be9567"] , defaultBodyParameters: nil))
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

