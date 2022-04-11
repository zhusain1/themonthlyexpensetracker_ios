//
//  Account.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/6/22.
//

import SwiftUI

struct AccountView: View {
    @ObservedObject var accountViewModel: AccountViewModel
    
    var token: String
    
    init(jwt: String){
        accountViewModel = AccountViewModel()
        self.token = jwt
        getAccounts()
    }
    
    func getAccounts(){
        Task{
            try await accountViewModel.getAccounts(jwt: token)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Branding()
                if accountViewModel.accountResponse != nil {
                    Text("Connected Accounts")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Net worth: \(accountViewModel.getNetWorth(accounts: accountViewModel.accountResponse!))")
                        .padding()
                        .font(.title3)
                        .padding(.bottom, 10)
                    ScrollView{
                        VStack(alignment: .leading, spacing: 4){
                            ForEach(accountViewModel.accountResponse!, id: \.accountId) { account in
                                NavigationLink(destination: TransactionView(jwt: token, accountId:account.accountId)) {
                                    HStack{
                                        Image(systemName: "banknote")
                                            .offset(x: 40)
                                        Text(account.name)
                                            .fontWeight(.bold)
                                            .padding()
                                            .font(.title3)
                                            .offset(x: 30)
                                        Spacer()
                                        VStack{
                                            HStack{
                                            Text(displayAccountBalance(balance: account.balance))
                                                .padding()
                                                .font(.title3)
                                                Image(systemName: "chevron.forward")
                                                        .offset(y: 20)
                                                
                                            }
                                            Text(account.type)
                                                .font(.subheadline)
                                                
                                        }
                                    }
                                    .offset(x: -30)
                                    
                                }
                                .foregroundColor(Color.black)
                                Divider()
                                    .background(Color.gray)
                            }
                        }
                    }
                } else{
                    Text("Loading Accounts")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 10)
                    ProgressView()
                }
                Spacer()
            }.offset(y: -120)
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(jwt: "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Inp1bGZpaHVzYWluMTk5NkBnbWFpbC5jb20iLCJzdWIiOiJadWxmZWthciBIdXNhaW4iLCJqdGkiOiI5ZTIyYTFlMC1iYjYwLTQwOTYtYTM1My1kYzRiNWI0Zjg5MjciLCJpYXQiOjE2NDkzNzQ3NTQsImV4cCI6MTY0OTM4NTU1NH0.iPUq-4I-f574xoBjw1j0n2nZq-UcHBPoHg-gmDvpNCQ")
    }
}
