//
//  SearchMapView.swift
//  CampingDiary
//
//  Created by 조향래 on 11/6/23.
//

import UIKit
import NMapsMap
import CoreLocation
import Combine

final class SearchMapView: UIView {
    private var locationManager = CLLocationManager()
    
    private let naverMapView = {
        let mapView = NMFNaverMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showLocationButton = true
        mapView.showZoomControls = true
        mapView.layer.borderWidth = 1.0
        mapView.layer.borderColor = UIColor.systemGreen.cgColor
        
        return mapView
    }()
    private lazy var searchTextFieldStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .white
        stackView.spacing = 4
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.layer.cornerRadius = 8.0
        stackView.layer.shadowOffset = CGSize(width: 2, height: 2)
        stackView.layer.shadowOpacity = 0.3
        
        return stackView
    }()
    private let searchTextField = {
        let textField = UITextField()
        textField.placeholder = "캠핑장 검색"
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return textField
    }()
    private lazy var searchButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(UIColor.placeholderText, for: .normal)
        button.isEnabled = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        return button
    }()
    private var buttonAction: (() -> Void)?
    private var subscriptions = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        layout()
        setupLocationData()
        bindTextToButtonState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        addSubview(naverMapView)
        addSubview(searchTextFieldStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            naverMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 8),
            naverMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -8),
            naverMapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            
            searchTextFieldStackView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 24),
            searchTextFieldStackView.widthAnchor.constraint(equalTo: naverMapView.widthAnchor, multiplier: 0.8),
            searchTextFieldStackView.centerXAnchor.constraint(equalTo: safe.centerXAnchor)
        ])
    }
    
    private func setupLocationData() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let defaultSeoulLatitude = 37.5642135
        let defualtSeoulLongitude = 127.0016985
        
        let latitude = locationManager.location?.coordinate.latitude ?? defaultSeoulLatitude
        let longitude = locationManager.location?.coordinate.longitude ?? defualtSeoulLongitude
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 7)
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    private func bindTextToButtonState() {
        searchTextField.publisher
            .sink { [weak self] in
                if $0.isEmpty {
                    self?.searchButton.isEnabled = false
                    self?.searchButton.setTitleColor(UIColor.placeholderText, for: .normal)
                } else {
                    self?.searchButton.isEnabled = true
                    self?.searchButton.setTitleColor(UIColor.systemBlue, for: .normal)
                }
            }
            .store(in: &subscriptions)
    }
    
    @objc private func searchButtonTapped() {
        buttonAction?()
    }
    
    func configureSearchButtonAction(action: @escaping () -> Void) {
        buttonAction = action
    }
}
