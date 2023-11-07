//
//  UITextField+publisher.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import UIKit
import Combine

extension UITextField {
    var publisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
