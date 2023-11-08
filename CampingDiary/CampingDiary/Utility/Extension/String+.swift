//
//  String+.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Foundation

extension String {
    static let numberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 7
        numberFormatter.maximumFractionDigits = 7
        
        return numberFormatter
    }()
    
    func toLatitude() -> Double {
        var text = self
        let index = text.index(text.startIndex, offsetBy: 2)
        text.insert(".", at: index)
        
        let number = String.numberFormatter.number(from: text)
        
        return number?.doubleValue ?? 0
    }
    
    func toLongitude() -> Double {
        var text = self
        let index = text.index(text.startIndex, offsetBy: 3)
        text.insert(".", at: index)
        
        let number = String.numberFormatter.number(from: text)
        
        return number?.doubleValue ?? 0
    }
    
    func toLocationTitle() -> String {
        var title = self.replacingOccurrences(of: "<b>", with: "")
        title = title.replacingOccurrences(of: "</b>", with: "")
        
        return title
    }
}

