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
    
    var body: some View {
        VStack {
            TextField(Constants.textFieldLabel, text: $identifier)
                .textFieldStyle(.roundedBorder)
            Button(Constants.registerPasskeyButton, action: registerWithPasskey)
            Button(Constants.loginPasskeyButon, action: loginWithPasskey)
            
        }
        .alert("Success", isPresented: $isShowingSuccessAlert) {
            
        }
        .padding()
    }
    
    func registerWithPasskey() {
        Task {
            do {
                let _ = try await passage.registerWithPasskey(identifier: identifier)
                isShowingSuccessAlert = true
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
    func loginWithPasskey() {
        Task {
            do {
                let _ = try await passage.loginWithPasskey()
                isShowingSuccessAlert = true
            } catch {
                print("Error: \(error)")
            }
        }
    }
    
}

#Preview {
    ContentView()
}
