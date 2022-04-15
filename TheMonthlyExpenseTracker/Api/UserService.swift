//
//  APICall.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/4/22.
//

import Foundation

class UserService{
    
    struct LoginResponse: Codable{
        var token: String
        var path: String
    }
    
    func getUser(_ email: String, _ password: String) async throws-> LoginResponse {
    
        // Getting values and creating json before sending request
        var request = URLRequest(url: URL(string: "https://monthly-expensetracker.herokuapp.com/user/login")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        

        let requestBody = UserRequest(email, password)
        
        let encoder = JSONEncoder()
        request.httpBody = try! encoder.encode(requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200
        else {
            throw ServiceError.InvalidRequest
        }
        
        do{
            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
            return loginResponse
        } catch{
            throw ServiceError.InvalidRequest
        }
    }
}
