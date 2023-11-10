//
//  SearchMapViewModel.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa

final class SearchMapViewModel {
    private let dataManager = DataManager.shared
    private var searchKeyworkd: String
    private let disposeBag = DisposeBag()
    private let searchedLocations = BehaviorRelay<[LocationItem]>(value: [])
    
    init(searchKeyworkd: String) {
        self.searchKeyworkd = searchKeyworkd
    }
    
    func fetch() {
        let provider = MoyaProvider<UserAPI>()
        
        provider.rx.request(.search(keyword: searchKeyworkd))
            .subscribe { [weak self] result in
                switch result {
                case let .success(response):
                    let locationDataDTO = Decoder.decodeJSON(response.data, returnType: LocationDataDTO.self)
                    guard let locationItems = locationDataDTO?.items else { return }
                    
                    self?.searchedLocations.accept(locationItems)
                case let .failure(error):
                    print(error)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getCellData() -> Observable<[LocationItem]> {
        return searchedLocations.asObservable()
    }
    
    func getSelectedLocation(at index: Int) -> LocationItem {
        return searchedLocations.value[index]
    }
    
    func configureSearchKeyword(_ keyword: String) {
        searchKeyworkd = keyword
    }
    
    func addBookmark(_ locationItem: LocationItem) {
        dataManager.addBookmark(locationItem)
    }
    
    func removeBookmark(_ locationItem: LocationItem) {
        dataManager.removeBookmark(locationItem)
    }
    
    func isBookmarked(_ locationItem: LocationItem) -> Bool {
        return dataManager.isBookmarked(locationItem)
    }
}
