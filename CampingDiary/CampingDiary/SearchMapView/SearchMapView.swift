//
//  SearchMapView.swift
//  CampingDiary
//
//  Created by 조향래 on 11/6/23.
//

import UIKit
import NMapsMap
import RxSwift
import RxCocoa

class SearchMapView: UIView {
    private var locationManager = CLLocationManager()
    
    private let naverMapView = {
        let mapView = NMFNaverMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showLocationButton = true
        mapView.showZoomControls = true
        mapView.layer.shadowOffset = CGSize(width: 0, height: 0)
        mapView.layer.shadowOpacity = 0.5
        
        return mapView
    }()
    private lazy var searchTextFieldStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchTextField, searchButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .systemBackground
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
        textField.textColor = .label
        textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        return textField
    }()
    let searchButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.placeholderText, for: .normal)
        button.isEnabled = false
        button.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var markerList: [NMFMarker] = []
    
    init(inputKeyword: String? = nil) {
        searchTextField.text = inputKeyword
        
        super.init(frame: .zero)
        
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
        
        naverMapView.addSubview(searchTextFieldStackView)
    }
    
    private func layout() {
        let safe = safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            naverMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 0),
            naverMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: 0),
            naverMapView.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -8),
            
            searchTextFieldStackView.topAnchor.constraint(equalTo: naverMapView.topAnchor, constant: 16),
            searchTextFieldStackView.widthAnchor.constraint(equalTo: naverMapView.widthAnchor, multiplier: 0.8),
            searchTextFieldStackView.centerXAnchor.constraint(equalTo: naverMapView.centerXAnchor)
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
        searchTextField.rx.text
            .bind { [weak self] text in
                guard let self else { return }
                
                if let text, !text.isEmpty {
                    searchButton.isEnabled = true
                    searchButton.setTitleColor(UIColor.systemBlue, for: .normal)
                } else {
                    searchButton.isEnabled = false
                    searchButton.setTitleColor(UIColor.placeholderText, for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
    
    func getText() -> String {
        return searchTextField.text ?? ""
    }
    
    func cleatText() {
        searchTextField.text = ""
        searchTextField.sendActions(for: .valueChanged)
    }
}

// MARK: control MapView's Marker
extension SearchMapView {
    func configureDefaultMarkers(locations: [Location]) {
        clearMarker()
        
        locations.forEach {
            markerList.append(NMFMarker(position: NMGLatLng(lat: $0.mapy.toLatitude(),
                                                            lng: $0.mapx.toLongitude())))
            markerList.last?.iconTintColor = .black
            markerList.last?.captionText = $0.title.toLocationTitle()
            markerList.last?.captionMinZoom = 10
            markerList.last?.mapView = naverMapView.mapView
        }
    }
    
    func configureBookmarkMarkers(locations: [Location]) {
        clearMarker()
        
        locations.forEach {
            markerList.append(NMFMarker(position: NMGLatLng(lat: $0.mapy.toLatitude(),
                                                            lng: $0.mapx.toLongitude())))
            markerList.last?.iconTintColor = .yellow
            markerList.last?.iconImage = NMFOverlayImage(image: UIImage(systemName: "star.fill")!)
            markerList.last?.captionText = $0.title.toLocationTitle()
            markerList.last?.captionMinZoom = 10
            markerList.last?.mapView = naverMapView.mapView
        }
    }
    
    private func clearMarker() {
        markerList.forEach {
            $0.mapView = nil
        }
        
        markerList.removeAll()
    }
    
    func focusMarker(at index: Int) {
        guard let latitude = markerList[safe: index]?.position.lat,
              let longitude = markerList[safe: index]?.position.lng else { return }
        
        moveCamera(latitude: latitude, longitude: longitude)
    }
    
    func highlightMarkerColor(at selectedIndex: Int) {
        for index in 0..<markerList.count {
            markerList[safe: index]?.iconTintColor = .black
            markerList[safe: index]?.isHideCollidedCaptions = false
        }
        
        markerList[safe: selectedIndex]?.iconTintColor = .yellow
        markerList[safe: selectedIndex]?.isHideCollidedCaptions = true
    }
    
    func moveCamera(latitude: Double, longitude: Double) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: latitude, lng: longitude), zoomTo: 13)
        naverMapView.mapView.moveCamera(cameraUpdate)
    }
}
