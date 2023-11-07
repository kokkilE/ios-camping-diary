//
//  HomeViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/5/23.
//

import UIKit
import NMapsMap
import CoreLocation

final class HomeViewController: UIViewController {
    private let searchMapView = SearchMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupSearchMapView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(searchMapView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchMapView.topAnchor.constraint(equalTo: safe.topAnchor),
            searchMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            searchMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            searchMapView.heightAnchor.constraint(equalTo: searchMapView.widthAnchor, multiplier: 1.0)
        ])
    }
    
    private func setupSearchMapView() {
        searchMapView.configureSearchButtonAction { [weak self] in
            let searchMapViewController = SearchMapViewController()
            
            self?.navigationController?.pushViewController(searchMapViewController, animated: false)
        }
    }
}
