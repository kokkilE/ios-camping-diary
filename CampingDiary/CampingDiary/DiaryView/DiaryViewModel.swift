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
    private var editingDiary = BehaviorRelay<Diary?>(value: nil)
    
    func getCellData() -> Observable<[UIImage?]> {
        return images.asObservable()
    }
    
    func add(_ image: UIImage) {
        var addedImages = images.value
        addedImages.append(image)
        
        images.accept(addedImages)
    }
    
    func configureDiary(_ location: Location) {
        if var newDiary = editingDiary.value {
            newDiary.location = location
            editingDiary.accept(newDiary)
            
            return
        }
        
        let newDiary = Diary(location: location, content: "", campSite: "", visitDate: "", editDate: "")
        editingDiary.accept(newDiary)
    }
    
    func getObservableEditingDiary() -> Observable<Diary?> {
        return editingDiary.asObservable()
    }
}
