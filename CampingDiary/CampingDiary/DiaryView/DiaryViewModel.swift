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
    
    func getCellData() -> Observable<[UIImage?]> {
        return images.asObservable()
    }
}
