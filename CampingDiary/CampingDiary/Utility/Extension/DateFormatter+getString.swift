//
//  DateFormatter+getString.swift
//  CampingDiary
//
//  Created by 조향래 on 11/17/23.
//

import Foundation

extension DateFormatter {
    static func getString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        return dateFormatter.string(from: date)
    }
    
    static func getLongStringForKey(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MMMM dd HH:mm:ss"
        
        return dateFormatter.string(from: date)
    }
    
    static func getDate(text: String?) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        guard let text else { return nil }
        
        return dateFormatter.date(from: text)
    }
}
