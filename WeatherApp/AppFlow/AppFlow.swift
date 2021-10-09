//
//  AppFlow.swift
//  WeatherApp
//
//  Created by Arda Onat on 4.10.2021.
//

final class AppFlow {
    private let delegate: AppFlowDelegate
    
    init(delegate: AppFlowDelegate) {
        self.delegate = delegate
    }
    
    func start() {
        delegate.start()
    }
}
