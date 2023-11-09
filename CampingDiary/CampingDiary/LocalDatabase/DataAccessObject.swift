//
//  DataAccessObject.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import RealmSwift

protocol DataAccessObject where Self: Object {
    var roadAddress: String { get set }
}
