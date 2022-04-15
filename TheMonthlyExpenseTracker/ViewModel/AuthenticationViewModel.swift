//
//  UserRequestViewModel.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/3/22.
//

import Foundation
import LocalAuthentication

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
    
    
    func loginBiometric(completion: @escaping (Result<Bool,BioError>) -> Void) {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if canEvaluate {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Attempting to login") { success, error in
                DispatchQueue.main.async {
                    if error != nil {
                        completion(.failure(.biometrictError))
                    } else {
                        self.getSavedLogin()
                        completion(.success(true))
                    }
                }
            }
        }
    }

    
    func getSavedLogin() {
        let login = KeychainStorage.getLoginRequest()
        guard let loginRequest = login else {
            return
        }
        
        userRequest.email = loginRequest.email
        userRequest.password = loginRequest.password
    }
    
    
    @MainActor
    func loginSubmit() async{
        do{
            loginResponse = try await userService.getUser(userRequest.email, userRequest.password)
            KeychainStorage.saveLoginRequest(userRequest)
            isLoggedIn = true
            loginError = false
        } catch{
            isLoggedIn = false
            loginError = true
        }
    }
}
