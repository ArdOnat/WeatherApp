//
//  WeatherAppUITestsLaunchTests.swift
//  WeatherAppUITests
//
//  Created by Arda Onat on 14.10.2021.
//

import XCTest

class WeatherAppUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUp() {
        super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").launch()
        
        self.addUIInterruptionMonitor(withDescription: "Location permission", handler: { alert in
          alert.buttons["Allow While Using App"].tap()
          return true
        })
        super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").tapCoordinate(at: 0, and: 0)
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    func testLocationLabelExists() {
        let locationLabel = super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").staticTexts["locationLabel"]
        XCTAssert(locationLabel.waitForExistence(timeout:10))
    }
    
    func testWeatherStatusExists() {
        let weatherStatusLabel = super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").staticTexts["weatherStatusLabel"]
        XCTAssert(weatherStatusLabel.waitForExistence(timeout:10))
    }
    
    func testTemperatureLabelExists() {
        let temperatureLabel = super.getApp(with: "com.ardonat.WeatherApp.WeatherApp").staticTexts["temperatureLabel"]
        XCTAssertTrue(temperatureLabel.waitForExistence(timeout:10))
    }
}

extension XCTestCase {
    func getApp(with bundleString: String) -> XCUIApplication {
        return XCUIApplication(bundleIdentifier: bundleString)
    }
}

extension XCUIApplication {
    func tapCoordinate(at xCoordinate: Double, and yCoordinate: Double) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }
}
