//
//  ContentView.swift
//  passage-ios-uitest-app
//
//  Created by Ricky Padilla on 10/6/23.
//

import Passage
import SwiftUI

struct ContentView: View {
    
    let passage = PassageAuth(appId: Constants.appId)
    
    init() {
        passage.overrideApiUrl(with: Constants.apiUrl)
    }
    
    @State var identifier: String = ""
    @FocusState var textFieldIsFocused: Bool
    @State var isShowingSuccessAlert = false
    @State var isShowingFailureAlert = false
    @State var authToken = ""
    @State var failureMessage = ""
    
    var body: some View {
        VStack {
            TextField(Constants.textFieldLabel, text: $identifier)
                .textFieldStyle(.roundedBorder)
                .focused($textFieldIsFocused)
            Button(Constants.registerPasskeyButton, action: registerWithPasskey)
            Button(Constants.loginPasskeyButton, action: loginWithPasskey)
            Button(Constants.hostedAuthButton, action: hostedAuth)
            Button(Constants.hostedLogoutButton, action: hostedLogout)
            
        }
        .alert(Constants.successLabel, isPresented: $isShowingSuccessAlert) {} message: {
            Text("\(Constants.authTokenLabel)\(authToken)")
        }
        .alert(Constants.failureLabel, isPresented: $isShowingFailureAlert) {} message: {
            Text(failureMessage)
        }
        .padding()
    }
    
    func registerWithPasskey() {
        textFieldIsFocused = false
        Task {
            do {
                let authResult = try await passage.registerWithPasskey(identifier: identifier)
                authToken = authResult.authToken
                isShowingSuccessAlert = true
            } catch {
                print("⛔️ Error registering with passkey")
                print(error.localizedDescription)
                failureMessage = error.localizedDescription
                isShowingFailureAlert = true
            }
        }
    }
    
    func loginWithPasskey() {
        textFieldIsFocused = false
        Task {
            do {
                let authResult = try await passage.loginWithPasskey()
                authToken = authResult.authToken
                isShowingSuccessAlert = true
            } catch {
                print("⛔️ Error logging in with passkey")
                print(error.localizedDescription)
                failureMessage = error.localizedDescription
                isShowingFailureAlert = true
            }
        }
    }
    
    func hostedAuth() {
        textFieldIsFocused = false
        Task {
            do {
                let authResult = try await passage.hostedAuth(clientSecret: "gyznHEG9LW7KB7GoNCDmaEbA8F3SpgNr")
                authToken = authResult.authToken
                isShowingSuccessAlert = true
            } catch {
                print("⛔️ Error with hosted auth")
                print(error.localizedDescription)
                failureMessage = error.localizedDescription
                isShowingFailureAlert = true
            }
        }
    }
    
    func hostedLogout() {
        textFieldIsFocused = false
        Task {
            do {
                try await passage.hostedLogout()
                isShowingSuccessAlert = true
            } catch {
                print("⛔️ Error with hosted auth")
                print(error.localizedDescription)
                failureMessage = error.localizedDescription
                isShowingFailureAlert = true
            }
        }
    }
    
}

//#Preview {
//    ContentView()
//}
