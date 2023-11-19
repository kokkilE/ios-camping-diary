//
//  DiaryViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/15/23.
//

import UIKit
import RxSwift
import RxCocoa

final class DiaryViewModel {
    private let dataManager = DataManager.shared
    private let disposeBag = DisposeBag()
    private let images = BehaviorRelay<[UIImage?]>(value: [nil])
    private var selectedLocation = BehaviorRelay<Location?>(value: nil)
    let originalDiary: Diary?
    
    init(_ diary: Diary? = nil) {
        guard let diary else {
            originalDiary = nil
            return
        }
        
        originalDiary = diary
        selectedLocation.accept(diary.location)
        
        if let images = diary.images {
            self.images.accept(images)
        }
    }
    
    func getCellData() -> Observable<[UIImage?]> {
        return images.asObservable()
    }
    
    func add(_ image: UIImage) {
        var addedImages = images.value
        addedImages.append(image)
        
        images.accept(addedImages)
    }
    
    func configure(_ location: Location) {
        selectedLocation.accept(location)
    }
    
    func getObservableEditingDiary() -> Observable<Location?> {
        return selectedLocation.asObservable()
    }
    
    func saveDiary(campSite: String?, visitDate: Date?, content: String?) throws {
        guard let location = selectedLocation.value else { throw DiaryError.nilLocation }
        
        let createDate = originalDiary != nil ? originalDiary!.createDate : Date()
        
        let diary = Diary(location: location, campSite: campSite,
                          visitDate: visitDate, editDate: Date(), createDate: createDate,
                          content: content, images: images.value)
        
        if originalDiary == nil {
            dataManager.addDiary(diary)
            return
        }
        dataManager.updateDiary(diary)
    }
    
    func containImage(_ image: UIImage) -> Bool {
        return images.value.contains { existingImage in
            guard let existingImageData = existingImage?.pngData(),
                  let newImageData = image.pngData() else {
                return false
            }
            
            return existingImageData == newImageData
        }
    }
}
