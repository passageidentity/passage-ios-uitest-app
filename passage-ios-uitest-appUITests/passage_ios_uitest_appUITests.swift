//
//  passage_ios_uitest_appUITests.swift
//  passage-ios-uitest-appUITests
//
//  Created by Ricky Padilla on 10/6/23.
//

import XCTest

final class passage_ios_uitest_appUITests: XCTestCase {
    let app = XCUIApplication()
    
    // Shows permissions alerts (like native passkey UI) on top of the app.
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    func testSuccessfulPasskeyRegistration() {
        // Enroll simulator in biometrics - Face ID or Touch ID.
        Biometrics.enrolled()
        app.launch()
        let textField = app.textFields[Constants.textFieldLabel]
        textField.tap()
        textField.typeText(Helpers.newUserEmail())
        app.buttons[Constants.registerPasskeyButton].tap()
        // Check if iOS passkey alert and button appear.
        let passkeyContinueButton = springboard.staticTexts[Constants.systemContinueButton].firstMatch
        XCTAssertTrue(passkeyContinueButton.waitForExistence(timeout: 5))
        passkeyContinueButton.tap()
        // Simulate a successful biometric scan.
        Biometrics.successfulAuthentication()
        // If passkey flow is successful, the app should show a success alert along with the Passage auth token.
        let successAlert = app.alerts[Constants.successLabel].firstMatch
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5))
        let predicate = NSPredicate(format: "label BEGINSWITH '\(Constants.authTokenLabel)'")
        let authTokenMessage = successAlert.scrollViews.otherElements.staticTexts.matching(predicate).element(boundBy: 0).label
        XCTAssertTrue(authTokenMessage.count > Constants.authTokenLabel.count)
    }
    
    func testSuccessfulPasskeyLogin() {
        // Enroll simulator in biometrics - Face ID or Touch ID.
        Biometrics.enrolled()
        app.launch()
        app.buttons[Constants.loginPasskeyButton].tap()
        // Check if iOS passkey alert and button appear.
        let passkeyContinueButton = springboard.staticTexts[Constants.systemContinueButton].firstMatch
        XCTAssertTrue(passkeyContinueButton.waitForExistence(timeout: 5))
        passkeyContinueButton.tap()
        // Simulate a successful biometric scan.
        Biometrics.successfulAuthentication()
        // If passkey flow is successful, the app should show a success alert along with the Passage auth token.
        let successAlert = app.alerts[Constants.successLabel].firstMatch
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5))
        let predicate = NSPredicate(format: "label BEGINSWITH '\(Constants.authTokenLabel)'")
        let authTokenMessage = successAlert.scrollViews.otherElements.staticTexts.matching(predicate).element(boundBy: 0).label
        XCTAssertTrue(authTokenMessage.count > Constants.authTokenLabel.count)
    }

}
