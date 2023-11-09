//
//  LocationItemDAO.swift
//  CampingDiary
//
//  Created by 조향래 on 11/9/23.
//

import RealmSwift

final class LocationItemDAO: Object, DataAccessObject {
    @Persisted var title: String
    @Persisted(primaryKey: true) var roadAddress: String
    @Persisted var mapx: String
    @Persisted var mapy: String
}
