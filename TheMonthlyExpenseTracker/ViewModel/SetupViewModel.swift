//
//  SetupViewModel.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/6/22.
//

import Foundation

class SetupViewModel:ObservableObject{
    
    @Published
    var token: String
    
    var url: String
    
    init(token:String){
        self.token = token
        url = "http://localhost:3000/setup/"
    }
    
    func generatePath() -> URL {
        url.append(contentsOf: token)
        return URL(string: url)!
    }
    
}
