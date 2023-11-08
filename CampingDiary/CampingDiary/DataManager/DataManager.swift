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
    
    private var bookmarks = BehaviorRelay<[LocationItem]>(value: [])
    var observableBookmarks: Observable<[LocationItem]> {
        return bookmarks.asObservable()
    }
    
    private init() {}
    
    func addBookmark(_ locationItem: LocationItem) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.append(locationItem)
        
        bookmarks.accept(currentBookmarks)
    }
    
    func removeBookmark(_ locationItem: LocationItem) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.removeAll {
            $0.roadAddress == locationItem.roadAddress
        }
        
        bookmarks.accept(currentBookmarks)
    }
    
    func isBookmarked(_ locationItem: LocationItem) -> Bool {
        return bookmarks.value.contains {
            $0.roadAddress == locationItem.roadAddress
        }
    }
}
