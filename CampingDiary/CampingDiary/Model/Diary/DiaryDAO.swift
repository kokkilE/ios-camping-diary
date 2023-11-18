//
//  DiaryDAO.swift
//  CampingDiary
//
//  Created by 조향래 on 11/18/23.
//

import UIKit
import RealmSwift

final class DiaryDAO: Object, DataAccessObject {
    @Persisted(primaryKey: true) var primaryKey = UUID().uuidString
    
    @Persisted var location: DiaryLocationItemDAO?
    @Persisted var campSite: String?
    @Persisted var visitDate: Date?
    @Persisted var editDate: Date
    @Persisted var content: String?
    @Persisted var imageData: List<DiaryImageDataDAO>
    
    var images: [UIImage?] {
        return imageData.map { $0.getImage() }
    }
    
    convenience init(_ diary: Diary) {
        self.init()
        
        self.location = DiaryLocationItemDAO(diary.location)
        self.campSite = diary.campSite
        self.visitDate = diary.visitDate
        self.editDate = diary.editDate
        self.content = diary.content
        self.imageData = List<DiaryImageDataDAO>()
        
        diary.images?.forEach {
            imageData.append(DiaryImageDataDAO($0))
        }
    }
}
