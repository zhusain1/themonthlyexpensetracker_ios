//
//  TheMonthlyExpenseTrackerApp.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import SwiftUI

@main
struct TheMonthlyExpenseTrackerApp: App {
    
    @StateObject var authenticationViewModel =  AuthenticationViewModel()
    
    var body: some Scene {
        WindowGroup {
            if authenticationViewModel.isLoggedIn == true && authenticationViewModel.loginResponse!.path.elementsEqual("setup"){
                HomeView(
                    SetupViewModel(token: authenticationViewModel.loginResponse!.token)
                )
            } else if authenticationViewModel.isLoggedIn == true{
                AccountView(jwt: authenticationViewModel.loginResponse!.token)
            } else{
                LoginView().environmentObject(authenticationViewModel)
            }
        }
    }
}
