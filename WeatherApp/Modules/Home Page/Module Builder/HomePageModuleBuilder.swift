//
//  HomePageModuleBuilder.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import NetworkModule

final class HomePageModuleBuilder {
    
    static func generate() -> HomePageViewController {
        let wireframe: HomePageWireframeProtocol = HomePageWireframe()
        var service: HomePageServiceProtocol = HomePageService(homeApi: ApiClient.shared)
        let interactor: HomePageInteractor = HomePageInteractor(service: service)
        let presenter: HomePagePresenter = HomePagePresenter(interactor: interactor, wireframe: wireframe)
        let view: HomePageViewController = HomePageViewController(presenter: presenter)
            
        presenter.view = WeakRef(view)
        interactor.output = WeakRef(presenter)
        service.output = WeakRef(interactor)
        
        return view
    }
}

