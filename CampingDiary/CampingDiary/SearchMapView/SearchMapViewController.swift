//
//  SearchMapViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import UIKit
import RxSwift

final class SearchMapViewController: UIViewController {
    // MARK: define properties & init
    private let searchMapView: SearchMapView
    private lazy var tableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SearchMapTableViewCell.self, forCellReuseIdentifier: SearchMapTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        
        return tableView
    }()
    
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
}

// MARK: methods
extension SearchMapViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupNavigationLeftBarButtonItem()
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
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 0.8),
            
            tableView.topAnchor.constraint(equalTo: searchMapView.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupNavigationLeftBarButtonItem() {
        let backImage = UIImage(systemName: "arrow.left")
        
        let leftBarButton = UIBarButtonItem(image: backImage)
        leftBarButton.tintColor = .systemBlue
        leftBarButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                navigationController?.popViewController(animated: false)
            }
            .disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func requestFetch() {
        viewModel.fetch()
    }
    
    private func bindToTableView() {
        viewModel
            .getCellData()
            .bind(to: tableView.rx.items(
                cellIdentifier: SearchMapTableViewCell.reuseIdentifier,
                cellType: SearchMapTableViewCell.self)
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
                
                cell.configure(title: locationItem.title.toLocationTitle(),
                               address: locationItem.roadAddress)
                
                if viewModel.isBookmarked(locationItem) {
                    cell.toggleBookmarkButtonImage(shouldFiilStar: true)
                } else {
                    cell.toggleBookmarkButtonImage(shouldFiilStar: false)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindToSearchMapView() {
        searchMapView.searchButton.rx.tap
            .bind { [weak self] in
                guard let self else { return }
                
                let searchKeyword = searchMapView.getText()
                viewModel.configureSearchKeyword(searchKeyword)
                viewModel.fetch()
            }
            .disposed(by: disposeBag)
        
        viewModel
            .getCellData()
            .bind { [weak self] locationItems in
                guard let self,
                      let longitude = locationItems.first?.mapx.toLongitude(),
                      let latitude = locationItems.first?.mapy.toLatitude() else { return }
                
                searchMapView.moveCamera(latitude: latitude, longitude: longitude)
                searchMapView.configureDefaultMarkers(locations: locationItems)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: UITableViewDelegate
extension SearchMapViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchMapView.focusMarker(at: indexPath.item)
        searchMapView.highlightMarkerColor(at: indexPath.item)
    }
}
