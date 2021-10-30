//
//  NavigationControllerRouter+HomeNavigation.swift
//  WeatherApp
//
//  Created by Arda Onat on 3.10.2021.
//

import HomeModule

extension NavigationManager: HomeNavigation {
    func routeToDetail() {
    }
}

extension NavigationManager: HomeViewOperationHandler {
    func showToast(with errorMessage: String) {
        self.showToastMessageView(with: errorMessage)
    }
}
