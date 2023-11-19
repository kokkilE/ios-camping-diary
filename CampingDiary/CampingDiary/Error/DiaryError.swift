//
//  DiaryError.swift
//  CampingDiary
//
//  Created by 조향래 on 11/17/23.
//

import Foundation

enum DiaryError: LocalizedError {
    case nilLocation
}

extension DiaryError {
    var errorDescription: String? {
        switch self {
        case .nilLocation:
            "캠핑장은 필수 입력 항목입니다. \n 캠핑장을 입력해주세요."
        }
    }
}
