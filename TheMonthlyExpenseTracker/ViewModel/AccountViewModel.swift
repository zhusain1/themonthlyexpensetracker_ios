//
//  AccountViewModel.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/6/22.
//

import Foundation

class AccountViewModel: ObservableObject{

    var accountService:AccountService = AccountService()
    
    @Published
    var accountResponse: [AccountResponse]?
    
    init(){
        
    }
    
    @MainActor
    func getAccounts(jwt : String) async throws -> [AccountResponse]{
        do{
            accountResponse = try await accountService.getAccounts(jwt: jwt)
            return accountResponse!
        } catch{
            throw ServiceError.ParsingException
        }
    }
    
    func getNetWorth(accounts: [AccountResponse]) -> String{
        var total = 0.0
        for account in accounts {
            total += account.balance
        }
        return displayAccountBalance(balance: total)
    }
}
