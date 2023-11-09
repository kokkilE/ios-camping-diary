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
    
    private var bookmarks = BehaviorRelay<[LocationItem]>(value: [])
    var observableBookmarks: Observable<[LocationItem]> {
        return bookmarks.asObservable()
    }
    
    private init() {
        initializeBookmarks()
    }
}

// MARK: manage bookmarks data
extension DataManager {
    private func initializeBookmarks() {
        let bookmarks = realmManager
            .readAll(type: LocationItemDAO.self)?
            .compactMap { data in
                if let locationItemDAO = data as? LocationItemDAO {
                    let location = LocationItem(title: locationItemDAO.title, link: "",
                                            category: "", description: "",
                                            telephone: "", address: "",
                                            roadAddress: locationItemDAO.roadAddress,
                                            mapx: locationItemDAO.mapx,
                                            mapy: locationItemDAO.mapy)
                    
                    return location
                }
                
                return nil
            }
        
        guard let bookmarks else { return }
        
        self.bookmarks.accept(bookmarks)
    }
    
    func addBookmark(_ locationItem: LocationItem) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.append(locationItem)
        
        bookmarks.accept(currentBookmarks)
        realmManager.create(LocationItemDAO(locationItem))
    }
    
    func removeBookmark(_ locationItem: LocationItem) {
        var currentBookmarks = bookmarks.value
        currentBookmarks.removeAll {
            $0.roadAddress == locationItem.roadAddress
        }
        
        bookmarks.accept(currentBookmarks)
        realmManager.delete(LocationItemDAO(locationItem))
    }
    
    func isBookmarked(_ locationItem: LocationItem) -> Bool {
        return bookmarks.value.contains {
            $0.roadAddress == locationItem.roadAddress
        }
    }
}
