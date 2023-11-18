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
    
    func addDiary(campSite: String?, visitDate: String?, content: String?) throws {        
        guard let location = selectedLocation.value else { throw DiaryError.nilLocation }
        
        let diary = Diary(location: location, campSite: campSite,
                          visitDate: visitDate, editDate: DateFormatter.getString(date: Date()),
                          content: content, images: images.value)
        
        dataManager.addDiary(diary)
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
