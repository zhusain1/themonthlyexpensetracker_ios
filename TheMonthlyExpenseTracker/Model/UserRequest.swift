//
//  UserRequest.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import Foundation

class UserRequest:Codable{
    
    init(){
        email = ""
        password = ""
    }
    
    init(_ email: String, _ password: String){
        self.email = email
        self.password = password
    }
    
    
    var email: String
    
    var password: String
}
