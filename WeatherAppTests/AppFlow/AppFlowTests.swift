//
//  AppFlowTests.swift
//  WeatherAppTests
//
//  Created by Arda Onat on 20.08.2021.
//

@testable import WeatherApp

import XCTest

class AppFlowTests: XCTestCase {

    // MARK: - Life Cycle
    override func setUp() {
        super.setUp()
    }
    
    func testDidAppFlowDelegateStart() {
        // Given
        let delegate = AppFlowDelegateSpy()
        let sut = makeSUT(with:  delegate)
        
        // When
        sut.start()
        
        // Then
        XCTAssertTrue(delegate.didCalledStart)
    }
    
    private func makeSUT(with delegate: AppFlowDelegate) -> AppFlow {
        return AppFlow(delegate: delegate)
    }
    
    private class AppFlowDelegateSpy: AppFlowDelegate {
        
        var didCalledStart: Bool = false
        
        func start() {
            self.didCalledStart = true
        }
    }
}
