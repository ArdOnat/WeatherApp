//
//  HomePageModuleBuilder.swift
//  WeatherApp
//
//  Created by Arda Onat on 20.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import NetworkModule

final class HomePageModuleBuilder {
    
    static func generate(networkLayer: NetworkLayer) -> HomePageViewController {
        let wireframe: HomePageWireframeProtocol = HomePageWireframe()
        let service: HomePageServiceProtocol = HomePageService(networkLayer: networkLayer)
        var repository: HomePageRepositoryProtocol = HomePageRepository(service: service)
        let interactor: HomePageInteractor = HomePageInteractor(repository: repository)
        let presenter: HomePagePresenter = HomePagePresenter(interactor: interactor, wireframe: wireframe)
        let view: HomePageViewController = HomePageViewController(presenter: presenter)
            
        presenter.view = WeakRef(view)
        interactor.output = WeakRef(presenter)
        repository.output = WeakRef(interactor)
        
        return view
    }
}
