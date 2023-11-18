//
//  HomeViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import RxSwift

final class HomeViewModel {
    private let dataManager = DataManager.shared
    private let disposeBag = DisposeBag()
    
    func getObservableBookmarks() -> Observable<[Location]> {
        return dataManager.observableBookmarks
    }
    
    func getObservableDiary() -> Observable<[Diary?]> {
        return dataManager.observableDiaries
    }
    
    func removeBookmark(_ location: Location) {
        dataManager.removeBookmark(location)
    }
    
    func removeDiary(_ diary: Diary) {
        dataManager.removeDiary(diary)
    }
}
