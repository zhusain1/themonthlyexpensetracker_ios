//
//  GlobalFunctions.swift
//  TheMonthlyExpenseTracker
//
//  Created by Zulfi Husain on 4/8/22.
//

import Foundation

let months = ["January",
              "February",
              "March",
              "April",
              "May",
              "June",
              "July",
              "August",
              "September",
              "October",
              "November",
              "December"]

func displayAccountBalance(balance: Double)-> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    guard let val = formatter.string(from: balance as NSNumber) else {
        return ""
    }
    return val
}

func getCurrentMonth()-> String{
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "LLLL"
    return dateFormatter.string(from: date)
}

func parseDate(date:String)-> String{
    // 2022-02-18
    let parsedDate = date.components(separatedBy: "-")
    let monthAsInt = Int(parsedDate[1])! - 1
    return months[monthAsInt]
}
