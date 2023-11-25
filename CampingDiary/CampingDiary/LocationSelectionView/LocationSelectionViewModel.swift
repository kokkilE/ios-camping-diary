//
//  LocationSelectionViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/16/23.
//

import Moya
import RxSwift
import RxCocoa

final class LocationSelectionViewModel {
    private let dataManager = DataManager.shared
    private var searchKeyworkd: String?
    private let disposeBag = DisposeBag()
    private let searchedLocations = BehaviorRelay<[Location]>(value: [])
    
    func fetch() {
        guard let searchKeyworkd else { return }
        
        let provider = MoyaProvider<UserAPI>()
        
        provider.rx.request(.search(keyword: searchKeyworkd))
            .subscribe { [weak self] result in
                guard let self else { return }
                
                switch result {
                case let .success(response):
                    let locationDataDTO = Decoder.decodeJSON(response.data, returnType: LocationDataDTO.self)
                    guard let locationItemDTOList = locationDataDTO?.items else { return }
                    
                    let locationList = locationItemDTOList.map { Location($0) }
                    
                    searchedLocations.accept(locationList)
                case let .failure(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getObservableSearchedLocations() -> Observable<[Location]> {
        return searchedLocations.asObservable()
    }
    
    func getObservableBookmarks() -> Observable<[Location]> {
        return dataManager.observableBookmarks
    }
    
    func getSearchedLocations() -> [Location] {
        return searchedLocations.value
    }
    
    func getBookmarks() -> [Location] {
        return dataManager.currentBookmarks
    }
    
    func configureSearchKeyword(_ keyword: String) {
        searchKeyworkd = keyword
    }
}
