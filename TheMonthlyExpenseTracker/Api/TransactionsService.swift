//
//  AccountService.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/6/22.
//

import Foundation

/*
 {
     "account_id": "dZjwP67YwVc9mPeoK5AQUd7R1we5MYU4kny0A",
     "amount": -2000.0,
     "category": [
     "Transfer",
     "Debit"
     ],
     "date": "2022-04-04",
     "name": "ONLINE TRANSFER TO HUSAIN Z CHECKING XXXXXX9600 REF #IB0DYSHQ9P ON 04/02/22"
 },
 */

struct TransactionsResponse: Codable {
    let accountResponse: AccountResponse
    let transactions: [TransactionResponse]
}


// MARK: - Transaction
struct TransactionResponse: Codable,Hashable {
    var account_id: String
    var amount: Double
    var category: [String]
    var date, name: String
}


class TransactionService{
    func getTransactions(jwt: String, accountId: String) async throws -> TransactionsResponse {
        // Getting values and creating json before sending request
        
        var request = URLRequest(url: URL(string: "https://monthly-expensetracker.herokuapp.com/plaid/account/transactions")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(jwt, forHTTPHeaderField: "token")
        
        let requestBody = TransactionRequest(accountId)
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(requestBody)
                
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw ServiceError.InvalidRequest
        }
        
        do{
            let transactionsResponse = try JSONDecoder().decode(TransactionsResponse.self, from: data)
            
            print(transactionsResponse)
            
            return transactionsResponse
        } catch{
            print(error)
            throw ServiceError.InvalidRequest
        }
        
    }
}


