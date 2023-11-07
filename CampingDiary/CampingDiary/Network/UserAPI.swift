//
//  UserAPI.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Foundation
import Moya

enum UserAPI {
    case search(keyword: String)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://openapi.naver.com")!
    }
    
    var path: String {
        return "/v1/search/local.json"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return nil
    }
}
