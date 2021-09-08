//
//  HomePageModuleBuilder.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
import CoreModule

final class HomePageModuleBuilder {
    
    static func generate(homeApi: HomeApi) -> HomePageViewController {
        let wireframe: HomePageWireframeProtocol = HomePageWireframe()
        var service: HomePageServiceProtocol = HomePageService(homeApi: homeApi)
        let interactor: HomePageInteractor = HomePageInteractor(service: service)
        let presenter: HomePagePresenter = HomePagePresenter(interactor: interactor, wireframe: wireframe)
        let view: HomePageViewController = HomePageViewController(presenter: presenter)
            
        presenter.view = WeakRef(view)
        interactor.output = WeakRef(presenter)
        service.output = WeakRef(interactor)
        
        return view
    }
}

