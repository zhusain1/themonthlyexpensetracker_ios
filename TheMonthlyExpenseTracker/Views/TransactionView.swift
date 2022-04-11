//
//  TransactionView.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/7/22.
//

import SwiftUI

struct TransactionView: View {
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    var jwt: String
    
    var accountId: String
        
    init(jwt: String, accountId: String){
        transactionViewModel = TransactionViewModel()
        self.jwt = jwt
        self.accountId = accountId
        getTransactions()
    }
    
    func getTransactions(){
        Task{
            try await transactionViewModel.getTransactions(jwt:jwt, accountId: accountId)
        }
    }
    
    var body: some View {
        VStack{
            if(transactionViewModel.transactonsResponse != nil){
                Text("Account Balance: \(displayAccountBalance(balance: transactionViewModel.transactonsResponse!.accountResponse.balance))")
                    .font(.title3)
                    .bold()
                Text("Monthly Gained: \(displayAccountBalance(balance:transactionViewModel.monthlySaved()))")
                    .font(.title3)
                    .bold()
                    .padding()
                Text("Monthly Spent: \(displayAccountBalance(balance:transactionViewModel.monthlySpent()))")
                    .font(.title3)
                    .bold()
                    .padding()
                Text("Monthly Balance: \(displayAccountBalance(balance:transactionViewModel.monthlySaved() + transactionViewModel.monthlySpent()))")
                    .font(.title3)
                    .bold()
                    .padding()
                HStack{
                    Text("Choose Month")
                    Spacer()
                    Picker("Months", selection: $transactionViewModel.month) {
                        ForEach(months, id: \.self) { displayMonth in
                            Text(displayMonth)
                        }
                    }
                }.padding()
                List{
                    ForEach(transactionViewModel.filterTransactionsByMonth(), id: \.self) { transaction in
                        VStack(alignment: .leading){
                            Text(transaction.name)
                                .bold()
                                .padding()
                            HStack{
                                Image(systemName: "dollarsign.circle.fill")
                                Text(displayAccountBalance(balance: transaction.amount))
        
                            }
                            .padding()
                            .offset(y: -20)
                            HStack{
                                Text(transaction.date)
                                    .padding()
                                ForEach(transaction.category, id: \.self){
                                    c in
                                    Text(c)
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                            }
                            .foregroundColor(Color.gray)
                            .offset(y: -30)
                        }
                    }.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: -30, trailing: 0))
                }
                .listStyle(.plain)
            } else{
                Text("Loading Transactions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                ProgressView()
            }
        }.offset(y:-30)
        Spacer()
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(jwt:"eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Inp1bGZpaHVzYWluMTk5NkBnbWFpbC5jb20iLCJzdWIiOiJadWxmZWthciBIdXNhaW4iLCJqdGkiOiI3NjUwYmQ5ZS0yYjJkLTRkZGQtODVjNy03YzlhN2I1YjkzMDgiLCJpYXQiOjE2NDk0NDY0MTcsImV4cCI6MTY0OTQ1NzIxN30.WfQH6aChEvzP-02g5YKJkIJN3Pc1SNwA7a26ilRkg7I",accountId:"dZjwP67YwVc9mPeoK5AQUd7R1we5MYU4kny0A")
    }
}
