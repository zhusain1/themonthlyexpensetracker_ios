//
//  TransactionView.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/7/22.
//

import SwiftUI

struct TransactionView: View {
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    @State var displayTransactions = true
    
    @State var showAccountBalance = false
    
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
                
                Text("Transactions")
                    .font(.title.bold())
                
                Button("View Account Information"){
                    showAccountBalance.toggle()
                }
                .sheet(isPresented: $showAccountBalance) {
                    AccountBalances(transactionViewModel)
                }
                .padding()
                .frame(width: 300)
                .background(
                    Color.black
                )
                .font(.body.bold())
                .cornerRadius(25)
                .foregroundColor(Color.white)
                .padding()
                
                HStack{
                    Text("Choose Month")
                    Spacer()
                    Picker("Choose Month", selection: $transactionViewModel.month) {
                        ForEach(months, id: \.self) { displayMonth in
                            Text(displayMonth)
                        }
                    }
                }
                .padding()
                .foregroundColor(.gray)

                if displayTransactions{
                    TransactionList(transactionViewModel: transactionViewModel)
                }
            } else{
                Text("Loading Transactions")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                ProgressView()
            }
        }
        Spacer()

    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(jwt:"eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Inp1bGZpaHVzYWluMTk5NkBnbWFpbC5jb20iLCJzdWIiOiJadWxmZWthciBIdXNhaW4iLCJqdGkiOiJlNGM2YzlhMC1iMDY0LTQ0ZDQtYWEzMS05NWIyYWU2MmZmMmMiLCJpYXQiOjE2NTAwMzgxODEsImV4cCI6MTY1MDA0ODk4MX0.FnQWZskHO9PY7BCjqVV7DsidhpwA08yDx5r-J9ogkfU",accountId:"dZjwP67YwVc9mPeoK5AQUd7R1we5MYU4kny0A")
    }
}

struct TransactionList: View {
    
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    init(transactionViewModel: TransactionViewModel){
        self.transactionViewModel = transactionViewModel
    }
    
    var body: some View {
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
    }
}

struct AccountBalances: View {
    
    @ObservedObject var transactionViewModel: TransactionViewModel
    
    @Environment(\.dismiss) var dismiss
    
    init(_ transactionViewModel:TransactionViewModel){
        self.transactionViewModel = transactionViewModel
    }
    
    var body: some View {
        
        
        Button("Back to transactions") {
            dismiss()
        }
        .padding()
        .foregroundColor(.black)
    
        List{
            HStack(){
                Text("Account Balance")
                    .foregroundColor(Color.gray)
                Spacer()
                Text((displayAccountBalance(balance: transactionViewModel.transactonsResponse!.accountResponse.balance)))
            }
            .padding()
            
            HStack(){
                Text("Gained")
                    .foregroundColor(Color.gray)
                Spacer()
                Text(displayAccountBalance(balance:transactionViewModel.monthlySaved()))
            }
            .padding()
            
            HStack(){
                Text("Spent")
                    .foregroundColor(Color.gray)
                Spacer()
                Text(displayAccountBalance(balance:transactionViewModel.monthlySpent()))
            }
            .padding()
            
            HStack(){
                Text("Monthly Balance")
                    .foregroundColor(Color.gray)
                Spacer()
                Text(displayAccountBalance(balance:transactionViewModel.monthlySaved() + transactionViewModel.monthlySpent()))
            }
            .padding()
        }
        .foregroundColor(Color.black)
    }
}
