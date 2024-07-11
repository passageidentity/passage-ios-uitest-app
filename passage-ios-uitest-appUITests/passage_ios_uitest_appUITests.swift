//
//  passage_ios_uitest_appUITests.swift
//  passage-ios-uitest-appUITests
//
//  Created by Ricky Padilla on 10/6/23.
//

import XCTest

let authUIRetryCount: Int = 7
let authUIWaitTime: TimeInterval = 5
let webAuthAlertTitle = "“passage-ios-uitest-app” Wants to Use “withpassage-uat.com” to Sign In"

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
        // So we retry up to `authUIRetryCount` times.
        for _ in 1...authUIRetryCount {
            // NOTE: The native passkey UI ALWAYS takes some time to appear - even when successful.
            // So we wait for existence for `passkeyContinueButtonWaitTime` seconds.
            passkeyContinueButtonIsDisplayed = passkeyContinueButton.waitForExistence(timeout: authUIWaitTime)
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
        XCTAssertTrue(passkeyContinueButton.waitForExistence(timeout: authUIWaitTime))
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
    
    func testHostedAuth() {
        // Enroll simulator in biometrics - Face ID or Touch ID.
        Biometrics.enrolled()
        app.launch()
        
        // PART ONE: OPEN HOSTED LOGIN WEB VIEW
        app.buttons[Constants.hostedAuthButton].tap()
        // Check if iOS web auth session alert appears.
        var webAuthSessionAlertIsDisplayed = false
        let webAuthSessionAlert = springboard.alerts[webAuthAlertTitle]
        // NOTE: When starting up simulator, device takes a while to get ASAuthorization service to a usable state.
        // So we retry up to `authUIRetryCount` times.
        for _ in 1...authUIRetryCount {
            // NOTE: The web auth session UI takes some time to appear - even when successful.
            // So we wait for existence for `authUIWaitTime` seconds.
            webAuthSessionAlertIsDisplayed = webAuthSessionAlert.waitForExistence(timeout: authUIWaitTime)
            if webAuthSessionAlertIsDisplayed {
                break
            } else {
                print("⚠️ web auth session not ready, try again...")
                // Dismiss failure alert and try again.
                app.alerts.firstMatch.buttons.firstMatch.tap()
                app.buttons[Constants.hostedAuthButton].tap()
            }
        }
        webAuthSessionAlert.scrollViews.otherElements.buttons[Constants.systemContinueButton].tap()
        
        // PART TWO: REGISTER NEW ACCOUNT IN WEB VIEW USING PASSKEY
        let webView = app.webViews
        webView.buttons["Register here."].tap()
        webView.textFields["example@email.com"].tap()
        webView.textFields["example@email.com"].typeText(Helpers.newUserEmail())
        webView.buttons["Continue"].tap()
        webView.buttons["Register with passkey"].tap()
        // Check if iOS passkey alert and button appear.
        let passkeyContinueButton = springboard.staticTexts[Constants.systemContinueButton].firstMatch
        XCTAssertTrue(passkeyContinueButton.waitForExistence(timeout: authUIWaitTime))
        passkeyContinueButton.tap()
        // Simulate a successful biometric scan.
        Biometrics.successfulAuthentication()
        // If passkey flow is successful, the app should show a success alert along with the Passage auth token.
        let successAlert = app.alerts[Constants.successLabel].firstMatch
        XCTAssertTrue(successAlert.waitForExistence(timeout: 5))
        let predicate = NSPredicate(format: "label BEGINSWITH '\(Constants.authTokenLabel)'")
        let authTokenMessage = successAlert.scrollViews.otherElements.staticTexts.matching(predicate).element(boundBy: 0).label
        XCTAssertTrue(authTokenMessage.count > Constants.authTokenLabel.count)
        
        // PART THREE: LOG OUT SUCCESSFULLY
        app.buttons[Constants.hostedLogoutButton].tap()
        // Check if web auth session alert and button appear.
        let alert = springboard.alerts[webAuthAlertTitle]
        XCTAssertTrue(alert.waitForExistence(timeout: authUIWaitTime))
        alert.scrollViews.otherElements.buttons[Constants.systemContinueButton].tap()
        // Wait for logout web view to show and be dismissed
        sleep(2)
    }

}
