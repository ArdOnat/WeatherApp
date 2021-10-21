//
//  NavigationControllerRouter+HomeNavigation.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import HomeModule

extension NavigationControllerRouter: HomeNavigation {
    func routeToDetail() {
        self.push(factory.homePageViewController())
    }
}

extension NavigationControllerRouter: HomeViewOperationHandler {
    func showToast(with errorMessage: String) {
        self.showToastMessageView(with: errorMessage)
    }
}
