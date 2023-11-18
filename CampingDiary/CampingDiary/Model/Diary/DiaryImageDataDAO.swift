//
//  DiaryImageDataDAO.swift
//  CampingDiary
//
//  Created by 조향래 on 11/18/23.
//

import UIKit
import RealmSwift

final class DiaryImageDataDAO: Object {
    @Persisted dynamic var imageData: Data?
    
    func getImage() -> UIImage? {
        guard let imageData else { return nil }
        
        return UIImage(data: imageData)
    }
    
    convenience init(_ image: UIImage? = nil) {
        self.init()
        
        self.imageData = image?.jpegData(compressionQuality: 1.0)
    }
}
