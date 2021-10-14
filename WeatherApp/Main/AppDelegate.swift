//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//
import ApiClient
import UIKit

// Composition Root
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appFlow: AppFlow?
    
    private lazy var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard window != nil else { return  false }
        
        // MARK: Setup ApiClient
        ApiClient.setup(ApiClient.DefaultParameterConfig(defaultURLParameters: ["appid": "4325b9f55f7d320b4237e7f840be9567"])) // insert apikey here
        
        // MARK: Setup Navigation Controller
        navigationController.setNavigationBarHidden(true, animated: false)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        startAppFlow()
        
        return true
    }
    
    private func startAppFlow() {
        let factory = ViewFactory(networkClient: ApiClient.shared)
        let router = NavigationControllerRouter(navigationController, factory: factory)
        factory.navigationDelegate = router
        
        appFlow = AppFlow(delegate: router)
        appFlow?.start()
    }
}
