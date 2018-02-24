//
//  LocationManager.swift
//  Explore Direction
//
//  Created by Ashis Laha on 11/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import CoreLocation

protocol LocationManagerDelegate: class {
    func locationManagerDidUpdateLocation(_ locationManager: LocationManager, location: CLLocation)
    func locationManagerDidUpdateHeading(_ locationManager: LocationManager, heading: CLLocationDirection, accuracy: CLLocationDirection)
    func updateDistance(distance : CLLocationDistance)
}

// Handles retrieving the location and heading from CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var delegate: LocationManagerDelegate?
    
    private var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var heading: CLLocationDirection?
    var headingAccuracy: CLLocationDegrees?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager?.distanceFilter = kCLDistanceFilterNone
        self.locationManager?.headingFilter = kCLHeadingFilterNone
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.delegate = self
        self.locationManager?.startUpdatingHeading()
        self.locationManager?.startUpdatingLocation()
        
        self.locationManager?.requestWhenInUseAuthorization()
        self.currentLocation = self.locationManager?.location
    }
    
    func requestAuthorization() {
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse {
            return
        }
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.denied ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.restricted {
            return
        }
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            self.delegate?.locationManagerDidUpdateLocation(self, location: location)
        }
        self.currentLocation = manager.location
        
        if #available(iOS 11.0, *) {
            if let carLocation = ARSetupUtility.shared.destination, let location = locations.last {
                let distance = location.distance(from: CLLocation(latitude: carLocation.latitude, longitude: carLocation.longitude))
                delegate?.updateDistance(distance: distance)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy >= 0 {
            self.heading = newHeading.trueHeading
        } else {
            self.heading = newHeading.magneticHeading
        }
        self.headingAccuracy = newHeading.headingAccuracy
        self.delegate?.locationManagerDidUpdateHeading(self, heading: self.heading!, accuracy: newHeading.headingAccuracy)
    }
    
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
}

