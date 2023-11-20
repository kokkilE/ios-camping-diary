//
//  SearchMapViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Moya
import RxSwift
import RxCocoa

final class SearchMapViewModel {
    private let dataManager = DataManager.shared
    private var searchKeyworkd: String
    private let disposeBag = DisposeBag()
    private let searchedLocations = BehaviorRelay<[Location]>(value: [])
    
    init(searchKeyworkd: String) {
        self.searchKeyworkd = searchKeyworkd
    }
    
    func fetch() {
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
    
    func getCellData() -> Observable<[Location]> {
        return searchedLocations.asObservable()
    }
    
    func getSelectedLocation(at index: Int) -> Location {
        return searchedLocations.value[index]
    }
    
    func configureSearchKeyword(_ keyword: String) {
        searchKeyworkd = keyword
    }
    
    func addBookmark(_ location: Location) {
        dataManager.addBookmark(location)
    }
    
    func removeBookmark(_ location: Location) {
        dataManager.removeBookmark(location)
    }
    
    func isBookmarked(_ location: Location) -> Bool {
        return dataManager.isBookmarked(location)
    }
}
