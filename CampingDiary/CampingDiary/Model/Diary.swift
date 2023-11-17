//
//  Diary.swift
//  CampingDiary
//
//  Created by 조향래 on 11/10/23.
//

import UIKit

struct Diary: Hashable {
    var location: Location
    var campSite: String?
    var visitDate: String?
    var editDate: String
    var content: String?
    var images: [UIImage?]?
}
