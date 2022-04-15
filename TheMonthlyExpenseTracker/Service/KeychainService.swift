//
//  KeychainService.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/11/22.
//

import Foundation


import SwiftKeychainWrapper

enum KeychainStorage {
    static let key = "login"
    
    static func getLoginRequest() -> UserRequest? {
        if let userRequestString = KeychainWrapper.standard.string(forKey: Self.key) {
            let jsonData = userRequestString.data(using: .utf8)!
            return try! JSONDecoder().decode(UserRequest.self, from: jsonData)
        } else {
            return nil
        }
    }
    
    static func saveLoginRequest(_ userRequest: UserRequest) {
        let jsonData = try! JSONEncoder().encode(userRequest)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        KeychainWrapper.standard.set(jsonString, forKey: Self.key) 
    }
}
