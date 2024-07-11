//
//  Constants.swift
//  passage-ios-uitest-app
//
//  Created by Ricky Padilla on 10/6/23.
//

import Foundation

struct Constants {
    // App config
    static let appId = "MMoXX5za6AydcLF0tTImz3om"
    static let apiUrl = "https://auth-uat.passage.dev/v1"
    static let oidcClientCode = "gyznHEG9LW7KB7GoNCDmaEbA8F3SpgNr"
    
    // App UI labels
    static let textFieldLabel = "email"
    static let successLabel = "success"
    static let failureLabel = "failure"
    static let registerPasskeyButton = "register with passkey"
    static let loginPasskeyButton = "login with passkey"
    static let hostedAuthButton = "hosted authorization"
    static let hostedLogoutButton = "hosted logout"
    static let systemContinueButton = "Continue"
    static let authTokenLabel = "auth token: "
    
    // Web UI labels
    static let registerHereButton = "Register here."
    static let emailPlaceholder = "example@email.com"
    static let webContinueButton = "Continue"
    static let webPasskeyRegisterButton = "Register with passkey"
}
