//
//  ReuseIdentifying.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import UIKit

protocol ReuseIdentifying {}

extension ReuseIdentifying {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifying {}
