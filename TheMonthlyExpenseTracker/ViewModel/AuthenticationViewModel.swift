//
//  UserRequestViewModel.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import Foundation

class AuthenticationViewModel: ObservableObject{
    @Published var userRequest = UserRequest()
    
    @Published var isLoggedIn : Bool
    
    @Published var loginError : Bool
    
    var loginResponse: UserService.LoginResponse?
    
    var userService:UserService = UserService()
    
    init(){
        self.isLoggedIn = false
        self.loginError = false
    }
    
    @MainActor
    func loginSubmit() async{
        do{
            loginResponse = try await userService.getUser(userRequest.email, userRequest.password)
            isLoggedIn = true
            loginError = false
        } catch{
            isLoggedIn = false
            loginError = true
        }
    }
}
