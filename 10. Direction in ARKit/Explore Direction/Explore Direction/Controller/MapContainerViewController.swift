//
//  MapContainerViewController.swift
//  Explore Direction
//
//  Created by Ashis Laha on 10/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import GoogleMaps

class MapContainerViewController: UIViewController {

    private var mapView : GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleGoogleMap()
    }
    
    private func handleGoogleMap() {
        guard let appDelegate = UIApplication.shared.delegate  as? AppDelegate else { return }
        if let userLocation = appDelegate.locationManager.location?.coordinate {
            googleMapSetUp(location: userLocation)
        }
    }
    
    private func googleMapSetUp(location : CLLocationCoordinate2D) {
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 16.0)
        mapView = GMSMapView.map(withFrame: self.view.bounds, camera: camera)
        mapView.isUserInteractionEnabled = false
        mapView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.addSubview(mapView)
    }
    
}
