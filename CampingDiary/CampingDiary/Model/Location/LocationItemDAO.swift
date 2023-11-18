//
//  LocationItemDAO.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import Foundation
import RealmSwift

final class LocationItemDAO: Object, DataAccessObject {
    @Persisted(primaryKey: true) var primaryKey = UUID().uuidString
    @Persisted var title: String
    @Persisted var roadAddress: String
    @Persisted var mapx: String
    @Persisted var mapy: String
    
    convenience init(_ location: Location?) {
        guard let location else {
            fatalError("Invalid DAO type provided for Location initialization.")
        }
        
        self.init()
        
        self.title = location.title
        self.roadAddress = location.roadAddress
        self.mapx = location.mapx
        self.mapy = location.mapy
    }
}
