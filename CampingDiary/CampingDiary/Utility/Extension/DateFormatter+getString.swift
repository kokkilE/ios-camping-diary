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
}
