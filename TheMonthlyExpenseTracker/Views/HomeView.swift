//
//  HomeView.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var setupViewModel : SetupViewModel
    
    init(_ setupViewModel : SetupViewModel){
        self.setupViewModel = setupViewModel
    }
    
    @State var showingSheet = true

    var body: some View {
        
        NavigationView{
            VStack(
                spacing: -10
            ){
                VStack{
                    Branding()
                    
                    Text("Login to add more accounts.")
                        .foregroundColor(Color.black)
                        .font(.title3)
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
    
                    Button("Connect Bank") {
                        showingSheet.toggle()
                    }
                    .padding()
                    .frame(width: 300)
                    .background(Color.black)
                    .font(.title3.bold())
                    .cornerRadius(25)
                    .foregroundColor(Color.white)
                    
                    .sheet(isPresented: $showingSheet) {
                        DisplaySetup(
                            url: setupViewModel.generatePath()
                        )
                    }
                    NavigationLink {
                        AccountView(jwt: setupViewModel.token)
                    } label: {
                        Text("Go to Connected Accounts")
                            .foregroundColor(Color.black)
                            .underline()
                            .font(.title2)
                            .padding(.top, 20)
                    }
                    Spacer()
                }
            }.offset(y: -120)
        }
    }
}

struct DisplaySetup: View{
    var url : URL
    
    @Environment(\.dismiss) var dismiss
    
    
    init(url:URL){
        self.url = url
    }
    
    var body: some View {
        ZStack{
            VStack{
                Button("Close",
                action:{
                    dismiss()
                })
                .padding()
                .foregroundColor(Color.black)
                    
                Webview(url: url)
            }
        }
        
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            SetupViewModel.init(token: "eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6Inp1bGZpaHVzYWluMTk5NkBnbWFpbC5jb20iLCJzdWIiOiJadWxmZWthciBIdXNhaW4iLCJqdGkiOiJjNTlhYTM3ZC0yODc2LTQxYmQtODFjNy1mMThjYTJiOTE4OWQiLCJpYXQiOjE2NDkyNzkwMzMsImV4cCI6MTY0OTI4OTgzM30.Dq3ZftIikyKriFGeFyYGgrOVbdnm605Wl-KXHEN7B6E")
        )
    }
}
