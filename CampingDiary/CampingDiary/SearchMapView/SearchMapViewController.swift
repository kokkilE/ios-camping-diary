//
//  SearchMapViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/7/23.
//

import UIKit

final class SearchMapViewController: UIViewController {
    private let viewModel: SearchMapViewModel
    
    init(keyword: String) {
        viewModel = SearchMapViewModel(searchKeyworkd: keyword)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        requestFetch()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func requestFetch() {
        viewModel.fetch()
    }
}
