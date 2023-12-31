//
//  Location.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import Foundation
import RealmSwift

struct Location: Hashable {
    let uuid = UUID()
    var title: String
    var roadAddress: String
    var mapx: String
    var mapy: String
}

extension Location {
    init(_ dto: DataTransferObject) {
        if let dto = dto as? LocationItemDTO {
            self.title = dto.title
            self.roadAddress = dto.roadAddress
            self.mapx = dto.mapx
            self.mapy = dto.mapy
            
            return
        }
        
        fatalError("Invalid DTO type provided for Location initialization.")
    }
    
    init(_ dao: DataAccessObject?) {
        guard let dao else {
            fatalError("Invalid DAO type provided for Location initialization.")
        }
        
        if let dao = dao as? LocationItemDAO {
            self.title = dao.title
            self.roadAddress = dao.roadAddress
            self.mapx = dao.mapx
            self.mapy = dao.mapy
            
            return
        }
        
        if let dao = dao as? DiaryLocationItemDAO {
            self.title = dao.title
            self.roadAddress = dao.roadAddress
            self.mapx = dao.mapx
            self.mapy = dao.mapy
            
            return
        }
        
        fatalError("Invalid DAO type provided for Location initialization.")
    }
}
