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
            ZStack {
                Color.bg
                    .ignoresSafeArea()
                VStack {
                    if accountViewModel.accountResponse != nil {
                        ZStack{
                            Color.black.opacity(0.8)
                            VStack {
                                Text("Linked Accounts")
                                        .font(.title2)
                                    .fontWeight(.bold)
                                Text("Net worth: \(accountViewModel.getNetWorth(accounts: accountViewModel.accountResponse!))")
                                    .padding()
                                    .font(.title2)
                                    .padding(.bottom, 10)
                                Image("account")
                                    .resizable()
                                    .frame( width: 150, height:120)
                            }
                            .offset(y:30)
                        }
                        .offset(y:-200)
                            .foregroundColor(.white)
                        .offset(y: 45)
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
                                                        .font(.body)
                                                    Image(systemName: "chevron.forward")
                                                        .offset(y: 20)
                                                    
                                                }
                                                Text(account.type)
                                                    .font(.subheadline)
                                                    .padding(.bottom, 10)
                                                
                                            }
                                        }
                                        .offset(x: -30)
                                        
                                    }
                                    .foregroundColor(Color.black)
                                    
                                }
                                .background(Color.white)
                                .clipped()
                                .padding()
                                .shadow(color: Color.black, radius: 2, x: 0.6, y: 1)
                            }
                        }
                        .offset(y: -150)
                    } else{
                        Text("Loading Accounts")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 10)
                        ProgressView()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct Account_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(jwt: "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Inp1bGZpaHVzYWluMTk5NkBnbWFpbC5jb20iLCJzdWIiOiJadWxmZWthciBIdXNhaW4iLCJqdGkiOiJmMjg0Zjk5My1lMGRkLTQ0ZjMtYTlmOS01Y2NjOTY4YTlkNjgiLCJpYXQiOjE2NDk5ODEzNDYsImV4cCI6MTY0OTk5MjE0Nn0.McaCy0GgaqUFizAdJYgvG0tG5GPG5I5tq0-M7kVwjuM")
    }
}
