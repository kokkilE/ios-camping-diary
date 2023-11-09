//
//  SearchMapViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import UIKit
import RxSwift

final class SearchMapViewController: UIViewController {
    private let searchMapView: SearchMapView
    private let tableView = UITableView()
    private let viewModel: SearchMapViewModel
    private let disposeBag = DisposeBag()
    
    init(keyword: String) {
        searchMapView = SearchMapView(inputKeyword: keyword)
        viewModel = SearchMapViewModel(searchKeyworkd: keyword)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupSearchMapView()
        setupTableView()
        requestFetch()
        bindToTableView()
        bindToSearchMapView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchMapView)
        view.addSubview(tableView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchMapView.topAnchor.constraint(equalTo: safe.topAnchor),
            searchMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 1.0),
            
            tableView.topAnchor.constraint(equalTo: searchMapView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupSearchMapView() {
        searchMapView.configureSearchButtonAction { [weak self] in
            guard let self else { return }
            
            let searchKeyword = searchMapView.getText()
            viewModel.configureSearchKeyword(searchKeyword)
            viewModel.fetch()
        }
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchMapViewTableViewCell.self, forCellReuseIdentifier: SearchMapViewTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
    private func requestFetch() {
        viewModel.fetch()
    }
    
    private func bindToTableView() {
        viewModel
            .getCellData()
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchMapViewTableViewCell.reuseIdentifier,
                cellType: SearchMapViewTableViewCell.self)
            ) { [weak self] index, locationItem, cell in
                guard let self else { return }
                
                cell.disposeBag = DisposeBag()
                cell.bookmarkButton.rx.tap
                    .bind { [weak self] in
                        guard let self else { return }
                        
                        if viewModel.isBookmarked(locationItem) {
                            viewModel.removeBookmark(locationItem)
                            cell.toggleBookmarkButtonImage(shouldFiilStar: false)
                            return
                        }
                        
                        viewModel.addBookmark(locationItem)
                        cell.toggleBookmarkButtonImage(shouldFiilStar: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                if viewModel.isBookmarked(locationItem) {
                    cell.toggleBookmarkButtonImage(shouldFiilStar: true)
                } else {
                    cell.toggleBookmarkButtonImage(shouldFiilStar: false)
                }
                
                cell.configure(title: locationItem.title.toLocationTitle(),
                               address: locationItem.roadAddress)
                
                searchMapView.configureMarkers(latitude: locationItem.mapy.toLatitude(),
                                               longitude: locationItem.mapx.toLongitude(),
                                               at: index)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindToSearchMapView() {
        viewModel
            .getCellData()
            .bind { [weak self] locationItems in
                guard let longitude = locationItems.first?.mapx.toLongitude(),
                      let latitude = locationItems.first?.mapy.toLatitude() else { return }
                
                self?.searchMapView.moveCamera(latitude: latitude,
                                               longitude: longitude)
            }
            .disposed(by: disposeBag)
    }
}

extension SearchMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLocation = viewModel.getSelectedLocation(at: indexPath.item)
        
        searchMapView.focusMarker(latitude: selectedLocation.mapy.toLatitude(),
                                  longitude: selectedLocation.mapx.toLongitude(),
                                  at: indexPath.item)
    }
}
