//
//  HomeViewController.swift
//  CampingDiary
//
//  Created by 조향래 on 11/5/23.
//

import UIKit
import NMapsMap
import CoreLocation

class HomeViewController: UIViewController {
    private var locationManager = CLLocationManager()
    
    private let naverMapView: NMFNaverMapView = {
        let mapView = NMFNaverMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showLocationButton = true
        mapView.showZoomControls = true
        mapView.layer.borderWidth = 1.0
        mapView.layer.borderColor = UIColor.systemGreen.cgColor
        
        return mapView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        layout()
        setupLocationData()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviews() {
        view.addSubview(naverMapView)
    }
    
    private func layout() {
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            naverMapView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 12),
            naverMapView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 12),
            naverMapView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -12),
            naverMapView.heightAnchor.constraint(equalTo: naverMapView.widthAnchor, multiplier: 1.0)
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
}
