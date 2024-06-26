//
//  passage_ios_uitest_appUITests.swift
//  passage-ios-uitest-appUITests
//
//  Created by Ricky Padilla on 10/6/23.
//

import XCTest

let passkeyUIRetryCount: Int = 7
let passkeyContinueButtonWaitTime: TimeInterval = 5

final class passage_ios_uitest_appUITests: XCTestCase {
    let app = XCUIApplication()
    
    // Shows permissions alerts (like native passkey UI) on top of the app.
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    func testSuccessfulPasskeyCreation() {
        // Enroll simulator in biometrics - Face ID or Touch ID.
        Biometrics.enrolled()
        app.launch()
        let textField = app.textFields[Constants.textFieldLabel]
        textField.tap()
        textField.typeText(Helpers.newUserEmail())
        app.buttons[Constants.registerPasskeyButton].tap()
        // Check if iOS passkey alert and button appear.
        var passkeyContinueButtonIsDisplayed = false
        let passkeyContinueButton = springboard.staticTexts[Constants.systemContinueButton].firstMatch
        // NOTE: When starting up simulator, device takes a while to get ASAuthorization service to a usable state.
        // So we retry up to `passkeyUIRetryCount` times.
        for _ in 1...passkeyUIRetryCount {
            // NOTE: The native passkey UI ALWAYS takes some time to appear - even when successful.
            // So we wait for existence for `passkeyContinueButtonWaitTime` seconds.
            passkeyContinueButtonIsDisplayed = passkeyContinueButton.waitForExistence(timeout: passkeyContinueButtonWaitTime)
            if passkeyContinueButtonIsDisplayed {
                break
            } else {
                print("⚠️ passkey ui not appearing, try again...")
                // Dismiss failure alert and try again.
                app.buttons["OK"].tap()
                app.buttons[Constants.registerPasskeyButton].tap()
            }
        }
        XCTAssertTrue(passkeyContinueButton.exists)
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
        XCTAssertTrue(passkeyContinueButton.waitForExistence(timeout: passkeyContinueButtonWaitTime))
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
