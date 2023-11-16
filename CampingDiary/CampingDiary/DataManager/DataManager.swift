//
//  DataManager.swift
//  CampingDiary
//
//  Created by 조향래 on 11/8/23.
//

import Foundation
import RxSwift
import RxCocoa

final class DataManager {
    static let shared = DataManager()
    
    private let realmManager = RealmManager()
    private var disposeBag = DisposeBag()
    
    private var diaries = BehaviorRelay<[Diary?]>(value: [])
    private var bookmarks = BehaviorRelay<[Location]>(value: [])
    
    private init() {
        initializeDiaries()
        initializeBookmarks()
    }
}

// MARK: manage diaries data
extension DataManager {
    var observableDiaries: Observable<[Diary?]> {
        return diaries.asObservable()
    }
    
    private func initializeDiaries() {
        // dummy data
        observableBookmarks
            .bind { bookmarks in
                var diaries: [Diary?] = [nil]
                
//                bookmarks.forEach {
//                    let diary = Diary(location: $0, content: "testing...", campSite: "A2", visitDate: Date(), editDate: Date())
//                    diaries.append(diary)
//                }
                
                self.diaries.accept(diaries)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: manage bookmarks data
extension DataManager {
    var observableBookmarks: Observable<[Location]> {
        return bookmarks.asObservable()
    }
    
    var currentBookmarks: [Location] {
        return bookmarks.value
    }
    
    private func initializeBookmarks() {
        let bookmarks = realmManager
            .readAll(type: LocationItemDAO.self)?
            .compactMap { data in
                if let locationItemDAO = data as? LocationItemDAO {
                    let location = Location(locationItemDAO)
                    
                    return location
                }
                
                return nil
            }
        
        guard let bookmarks else { return }
        
        self.bookmarks.accept(bookmarks)
    }
    
    func addBookmark(_ location: Location) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.append(location)
        
        bookmarks.accept(currentBookmarks)
        realmManager.create(LocationItemDAO(location))
    }
    
    func removeBookmark(_ location: Location) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.removeAll {
            $0.roadAddress == location.roadAddress
        }
        
        bookmarks.accept(currentBookmarks)
        realmManager.delete(LocationItemDAO(location))
    }
    
    func isBookmarked(_ location: Location) -> Bool {
        return bookmarks.value.contains {
            $0.roadAddress == location.roadAddress
        }
    }
}
