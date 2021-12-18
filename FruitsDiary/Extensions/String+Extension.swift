//
//  String+Extension.swift
//  FruitsDiary
//
//  Created by Gajula Ravi Kiran on 18/12/2021.
//

import Foundation

extension String {

    func getDateFromString() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let dateOut = formatter.date(from: self)
        return dateOut ?? Date()
        
    }
}

extension Date {
    
    func getStringFromDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
         return formatter.string(from: self)
    }
    
}
