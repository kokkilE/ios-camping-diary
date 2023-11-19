//
//  Diary.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import UIKit
import RealmSwift

struct Diary: Hashable {
    let uuid = UUID()
    var location: Location
    var campSite: String?
    var visitDate: Date?
    var editDate: Date
    var createDate: Date
    var content: String?
    var images: [UIImage?]?
}

extension Diary {
    init(_ dao: DataAccessObject) {
        if let dao = dao as? DiaryDAO {
            self.location = Location(dao.location)
            self.campSite = dao.campSite
            self.visitDate = dao.visitDate
            self.editDate = dao.editDate
            self.createDate = dao.createDate
            self.content = dao.content
            self.images = dao.images
            
            return
        }
        
        fatalError("Invalid DAO type provided for Location initialization.")
    }
}
