//
//  Helpers.swift
//  passage-ios-uitest-app
//
//  Created by Ricky Padilla on 10/6/23.
//

import Foundation

struct Helpers {
    
    static func newUserEmail() -> String {
        let currentDate = Int64(Date().timeIntervalSince1970 * 1000)
        let email = "ricky.padilla+iosuitest-\(currentDate)@passage.id"
        return email
    }
    
}
