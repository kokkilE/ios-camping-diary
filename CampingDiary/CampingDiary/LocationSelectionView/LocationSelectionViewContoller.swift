//
//  LocationSelectionViewContoller.swift
//  CampingDiary
//
//  Created by 조향래 on 11/16/23.
//

import UIKit
import RxSwift

final class LocationSelectionViewContoller: UIViewController {
    private let searchMapView: SearchMapView
    private let segmentedControl = {
        let segmentedControl = UISegmentedControl(items: [CellType.bookmark.description,
                                                          CellType.search.description])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = CellType.bookmark.rawValue
        
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.labelFontSize)]
        segmentedControl.setTitleTextAttributes(attribute, for: .normal)
        
        return segmentedControl
    }()
    private let tableView = UITableView()
    private let viewModel: LocationSelectionViewModel
    private let disposeBag = DisposeBag()
    var delegate: LocationReceivable?
    
    init() {
        searchMapView = SearchMapView(inputKeyword: "")
        viewModel = LocationSelectionViewModel()
        
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
        setupTableView()
        requestFetch()
        bindToSearchedLocation()
        bindToSecmentedControl()
        bindToSearchMapView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchMapView)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        let segmentedControlHeight = UIFont.labelFontSize + 12.0
        
        NSLayoutConstraint.activate([
            searchMapView.topAnchor.constraint(equalTo: safe.topAnchor),
            searchMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 0.8),
            
            segmentedControl.topAnchor.constraint(equalTo: searchMapView.bottomAnchor, constant: 12),
            segmentedControl.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            segmentedControl.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            segmentedControl.heightAnchor.constraint(equalToConstant: segmentedControlHeight),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12),
            tableView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            tableView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            tableView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(LocationSelectionTableViewCell.self, forCellReuseIdentifier: LocationSelectionTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
    }
    
    private func requestFetch() {
        viewModel.fetch()
    }
    
    private func bindToSearchedLocation() {
        viewModel
            .getObservableSearchedLocations()
            .skip(1)
            .bind { [weak self] _ in
                guard let self else { return }
                
                segmentedControl.selectedSegmentIndex = CellType.search.rawValue
                segmentedControl.sendActions(for: .valueChanged)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindToSecmentedControl() {
        segmentedControl.rx.selectedSegmentIndex
            .bind { [weak self] index in
                guard let self else { return }
                
                tableView.dataSource = nil
                
                if index == CellType.bookmark.rawValue {
                    configureCellForBookmarks()
                    configureMapMarkerForBookmarks()
                    return
                }
                
                if index == CellType.search.rawValue {
                    configureCellForSearchedLocations()
                    configureMapMarkerForSearchedLocations()
                    return
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCellForBookmarks() {
        viewModel
            .getObservableBookmarks()
            .bind(to: tableView.rx.items(
                cellIdentifier: LocationSelectionTableViewCell.reuseIdentifier,
                cellType: LocationSelectionTableViewCell.self)
            ) { [weak self] index, locationItem, cell in
                guard let self else { return }
                
                cell.disposeBag = DisposeBag()
                cell.bookmarkButton.rx.tap
                    .bind { [weak self] in
                        guard let self else { return }
                        
                        delegate?.receive(locationItem)
                        dismiss(animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.configure(title: locationItem.title.toLocationTitle(),
                               address: locationItem.roadAddress)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCellForSearchedLocations() {
        viewModel
            .getObservableSearchedLocations()
            .bind(to: tableView.rx.items(
                cellIdentifier: LocationSelectionTableViewCell.reuseIdentifier,
                cellType: LocationSelectionTableViewCell.self)
            ) { [weak self] index, locationItem, cell in
                guard let self else { return }
                
                cell.disposeBag = DisposeBag()
                cell.bookmarkButton.rx.tap
                    .bind { [weak self] in
                        guard let self else { return }
                        
                        delegate?.receive(locationItem)
                        dismiss(animated: true)
                    }
                    .disposed(by: cell.disposeBag)
                
                cell.configure(title: locationItem.title.toLocationTitle(),
                               address: locationItem.roadAddress)
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
    }
        
    private func configureMapMarkerForBookmarks() {
        let locations = viewModel.getBookmarks()

        searchMapView.configureBookmarkMarkers(locations: locations)
        
        guard let longitude = locations.first?.mapx.toLongitude(),
              let latitude = locations.first?.mapy.toLatitude() else { return }
        
        searchMapView.moveCamera(latitude: latitude, longitude: longitude)
    }
    
    private func configureMapMarkerForSearchedLocations() {
        let locations = viewModel.getSearchedLocations()

        searchMapView.configureDefaultMarkers(locations: locations)
        
        guard let longitude = locations.first?.mapx.toLongitude(),
              let latitude = locations.first?.mapy.toLatitude() else { return }
        
        searchMapView.moveCamera(latitude: latitude, longitude: longitude)
    }
}

extension LocationSelectionViewContoller: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchMapView.focusMarker(at: indexPath.item)
        searchMapView.highlightMarkerColor(at: indexPath.item)
    }
}

// MARK: enum for segmentedControl
extension LocationSelectionViewContoller {
    enum CellType: Int {
        case bookmark = 0
        case search = 1
        
        var description: String {
            switch self {
            case .bookmark:
                return "내 캠핑장"
            case .search:
                return "검색 결과"
            }
        }
    }
}
