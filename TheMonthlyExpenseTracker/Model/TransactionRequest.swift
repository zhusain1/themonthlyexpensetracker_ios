//
//  AccountRequest.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/7/22.
//

import Foundation

class TransactionRequest:Codable{
    
    init(){
        account_id = ""
    }
    
    init(_ account_id: String){
        self.account_id = account_id
    }
    
    var account_id: String
}
