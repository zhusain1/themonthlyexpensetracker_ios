//
//  AccountService.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/6/22.
//

import Foundation

/*
 {
    "accountId": "dZjwP67YwVc9mPeoK5AQUd7R1we5MYU4kny0A",
    "balance": 44090.31,
    "type": "checking",
    "name": "zulfi's savings"
},
 */
struct AccountResponse: Codable, Hashable{
    var accountId: String
    var balance: Double
    var type: String
    var name: String
}


class AccountService{
    func getAccounts(jwt: String) async throws -> [AccountResponse] {
        // Getting values and creating json before sending request
        
        var request = URLRequest(url: URL(string: "https://monthly-expensetracker.herokuapp.com/plaid/account/balances")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "token")
                
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw ServiceError.InvalidRequest
        }
        
        do{
            let accountResponse = try JSONDecoder().decode([AccountResponse].self, from: data)
            return accountResponse
        } catch{
            throw ServiceError.InvalidRequest
        }
        
    }
}

