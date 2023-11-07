//
//  Decoder.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Foundation

struct Decoder {
    private static let jsonDecoder = JSONDecoder()
    
    static func decodeJSON<element: Decodable>(_ data: Data, returnType: element.Type) -> element? {
        do {
            let result = try jsonDecoder.decode(returnType, from: data)
            
            return result
        } catch {
            return nil
        }
    }
}
