//
//  SearchMapViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

//import Foundation
import Combine
import Moya
import CombineMoya

final class SearchMapViewModel {
    private let searchKeyworkd: String
    private var subscriptions = Set<AnyCancellable>()
    @Published private(set) var searchedLocations = [LocationItem]()
    
    init(searchKeyworkd: String) {
        self.searchKeyworkd = searchKeyworkd
    }
    
    func fetch() {
        let provider = MoyaProvider<UserAPI>()
        
        provider.requestPublisher(.search(keyword: searchKeyworkd))
            .sink(receiveCompletion: { completion in
                guard case let .failure(error) = completion else { return }

                print(error)
            }, receiveValue: { [weak self] response in
                let locationData = Decoder.decodeJSON(response.data, returnType: LocationData.self)
                guard let locationItems = locationData?.items else { return }
                
                self?.searchedLocations.append(contentsOf: locationItems)
            })
            .store(in: &subscriptions)
    }
}
