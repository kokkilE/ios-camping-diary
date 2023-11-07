//
//  SearchMapViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Combine
import Moya
import CombineMoya

final class SearchMapViewModel {
    private let searchKeyworkd: String
    private var subscriptions = Set<AnyCancellable>()
    
    init(searchKeyworkd: String) {
        self.searchKeyworkd = searchKeyworkd
    }
    
    func fetch() {
        let provider = MoyaProvider<UserAPI>()
        
        provider.requestPublisher(.search(keyword: searchKeyworkd))
            .sink(receiveCompletion: { completion in
                guard case let .failure(error) = completion else { return }

                print(error)
            }, receiveValue: { response in
                print(response.data)
            })
            .store(in: &subscriptions)
    }
}