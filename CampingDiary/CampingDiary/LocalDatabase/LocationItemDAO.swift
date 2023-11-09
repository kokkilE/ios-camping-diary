//
//  LocationItemDAO.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import RealmSwift

final class LocationItemDAO: Object, DataAccessObject {
    @Persisted(primaryKey: true) var primaryKey: String
    @Persisted var title: String
    @Persisted var roadAddress: String
    @Persisted var mapx: String
    @Persisted var mapy: String
    
    init(_ locationItem: LocationItem) {
        super.init()
        
        self.primaryKey = locationItem.roadAddress
        self.title = locationItem.title
        self.roadAddress = locationItem.roadAddress
        self.mapx = locationItem.mapx
        self.mapy = locationItem.mapy
    }
}
