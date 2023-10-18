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
    @State var isShowingSuccessAlert = false
    @State var isShowingFailureAlert = false
    @State var authToken = ""
    
    var body: some View {
        VStack {
            TextField(Constants.textFieldLabel, text: $identifier)
                .textFieldStyle(.roundedBorder)
            Button(Constants.registerPasskeyButton, action: registerWithPasskey)
            Button(Constants.loginPasskeyButton, action: loginWithPasskey)
            
        }
        .alert(Constants.successLabel, isPresented: $isShowingSuccessAlert) {} message: {
            Text("\(Constants.authTokenLabel)\(authToken)")
        }
        .alert(Constants.failureLabel, isPresented: $isShowingFailureAlert) {}
        .padding()
    }
    
    func registerWithPasskey() {
        Task {
            do {
                let authResult = try await passage.registerWithPasskey(identifier: identifier)
                authToken = authResult.authToken
                isShowingSuccessAlert = true
            } catch {
                isShowingFailureAlert = true
            }
        }
    }
    
    func loginWithPasskey() {
        Task {
            do {
                let authResult = try await passage.loginWithPasskey()
                authToken = authResult.authToken
                isShowingSuccessAlert = true
            } catch {
                isShowingFailureAlert = true
            }
        }
    }
    
}

#Preview {
    ContentView()
}
