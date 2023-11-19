//
//  UICollectionView+longPressGesture.swift
//  CampingDiary
//
//  Created by 조향래 on 11/18/23.
//

import UIKit
import RxSwift

extension UICollectionViewCell {
    var longPressGesture: Observable<UILongPressGestureRecognizer> {
        let longPressGesture = UILongPressGestureRecognizer()
        addGestureRecognizer(longPressGesture)
        
        return longPressGesture.rx.event
            .filter { $0.state == .began }
            .asObservable()
    }
}
