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
        bindTableView()
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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
    }
    
    private func requestFetch() {
        viewModel.fetch()
    }
    
    private func bindTableView() {
        viewModel
            .getCellData()
            .bind(to: tableView.rx.items(
                cellIdentifier: UITableViewCell.reuseIdentifier,
                cellType: UITableViewCell.self)
            ) { index, locationItem, cell in
                var content = cell.defaultContentConfiguration()
                content.text = locationItem.title
                
                cell.contentConfiguration = content
            }
            .disposed(by: disposeBag)
    }
}
