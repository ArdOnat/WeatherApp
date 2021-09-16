//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//

import UIKit
import CoreModule
import HomeModule
import ApiClient

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard window != nil else { return  false }
        
        // MARK: Setup ApiClient
        ApiClient.setup(ApiClient.DefaultParameterConfig(defaultURLParameters: ["appid": ""])) // insert apikey here
        
        let homeViewController = HomePageModuleBuilder.generate(homeApi: ApiClient.shared)
        let navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
