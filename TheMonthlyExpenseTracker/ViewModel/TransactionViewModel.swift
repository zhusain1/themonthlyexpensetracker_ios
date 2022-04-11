//
//  TransactionViewModel.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/7/22.
//

import Foundation


import Foundation

class TransactionViewModel: ObservableObject{

    var transactionService:TransactionService = TransactionService()
    
    @Published
    var transactonsResponse: TransactionsResponse?
    
    @Published
    var month: String
    
    init(){
        month = getCurrentMonth()
    }
    
    @MainActor
    func getTransactions(jwt : String, accountId: String) async throws -> TransactionsResponse{
        do{
            transactonsResponse = try await transactionService.getTransactions(jwt: jwt, accountId: accountId)
            return transactonsResponse!
        } catch{
            throw ServiceError.ParsingException
        }
    }
    
    
    func filterTransactionsByMonth ()-> [TransactionResponse]{
        let filtered = transactonsResponse!.transactions.filter{
            parseDate(date: $0.date) == self.month
        }
        return filtered
    }
    
    func monthlySaved()-> Double {
        let filteredByMonth = filterTransactionsByMonth()
        
        let balance = filteredByMonth.filter{
            $0.amount > -1
        }.reduce(0, {$0 + $1.amount})
        
        return balance
    }
    
    func monthlySpent()-> Double {
        let filteredByMonth = filterTransactionsByMonth()
        
        let balance = filteredByMonth.filter{
            $0.amount < 0
        }.reduce(0, {$0 + $1.amount})
        
        return balance
    }
}
