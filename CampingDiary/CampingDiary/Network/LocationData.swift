//
//  LocationData.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Foundation

struct LocationData: Decodable {
    let lastBuildDate: String
    let total: Int
    let start: Int
    let display: Int
    let items: [LocationItem]
}

struct LocationItem: Decodable {
    let title: String
    let link: String
    let category: String
    let description: String
    let telephone: String
    let address: String
    let roadAddress: String
    let mapx: String
    let mapy: String
}
