//
//  DataAccessObject.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import RealmSwift

protocol DataAccessObject: Object {
    var primaryKey: String { get set }
    
    func update(_ data: DataAccessObject)
}
