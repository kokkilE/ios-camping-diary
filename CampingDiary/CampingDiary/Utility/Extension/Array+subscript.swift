//
//  Array+subscript.swift
//  CampingDiary
//
//  Created by 조향래 on 11/16/23.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        get {
            return indices ~= index ? self[index] : nil
        }
        set {
            guard let newValue,
                  indices ~= index else { return }
            
            self[index] = newValue
        }
    }
}
