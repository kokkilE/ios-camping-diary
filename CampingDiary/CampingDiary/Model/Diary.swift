//
//  Diary.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import Foundation

struct Diary: Hashable {
    var location: Location
    var content: String
    var campSite: String?
    var visitDate: String
    var editDate: String
}
