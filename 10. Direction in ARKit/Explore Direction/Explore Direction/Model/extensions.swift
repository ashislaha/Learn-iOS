//
//  extensions.swift
//  Explore Direction
//
//  Created by Ashis Laha on 18/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import SceneKit

extension CLLocation {
    
    public convenience init(coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    }
    
    /*
     Translates distance in meters between two locations.
     Returns the result as the distance in latitude and distance in longitude.
     */
    
    func translate(toLocation location: CLLocation) -> LocationTranslation {
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let distanceLatitude = location.distance(from: inbetweenLocation)
        let latitudeTranslation: Double
        latitudeTranslation = location.coordinate.latitude > inbetweenLocation.coordinate.latitude ? distanceLatitude : (0 - distanceLatitude)
        
        let distanceLongitude = self.distance(from: inbetweenLocation)
        let longitudeTranslation: Double
        longitudeTranslation = self.coordinate.longitude > inbetweenLocation.coordinate.longitude ? (0 - distanceLongitude) : distanceLongitude
        
        let altitudeTranslation = location.altitude - self.altitude
        return LocationTranslation(latitudeTranslation: latitudeTranslation, longitudeTranslation: longitudeTranslation,altitudeTranslation: altitudeTranslation)
    }
    
    // Reverse translation
    func translatedLocation(with translation: LocationTranslation) -> CLLocation {
        let latitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 0, distanceMeters: translation.latitudeTranslation)
        let longitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 90, distanceMeters: translation.longitudeTranslation)
        let coordinate = CLLocationCoordinate2D(latitude: latitudeCoordinate.latitude,longitude: longitudeCoordinate.longitude)
        let altitude = self.altitude + translation.altitudeTranslation
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
    }
}

extension Double {
    func metersToLatitude() -> Double { return self / (6360500.0) }
    func metersToLongitude() -> Double { return self / (5602900.0) }
}

extension CLLocationCoordinate2D {
    public func coordinateWithBearing(bearing:Double, distanceMeters:Double) -> CLLocationCoordinate2D {
        let distRadiansLat = distanceMeters.metersToLatitude() // earth radius in meters latitude
        let distRadiansLong = distanceMeters.metersToLongitude() // earth radius in meters longitude
        
        let lat1 = self.latitude * Double.pi / 180
        let lon1 = self.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadiansLat) + cos(lat1) * sin(distRadiansLat) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadiansLong) * cos(lat1), cos(distRadiansLong) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
}

extension CGPoint {
    static func pointWithVector(vector: SCNVector3) -> CGPoint {
        return CGPoint(x: CGFloat(vector.x), y: CGFloat(0 - vector.z))
    }
    
    func radiusContainsPoint(radius: CGFloat, point: CGPoint) -> Bool {
        let x = pow(point.x - self.x, 2)
        let y = pow(point.y - self.y, 2)
        let radiusSquared = pow(radius, 2)
        return x + y <= radiusSquared
    }
}

extension SCNVector3 {
    func distance(to anotherVector: SCNVector3) -> Float {
        return sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2))
    }
}

extension UIColor {
    class func getFontSideArrowColor() -> UIColor {
        return self.init(red: 239.0/255.0, green: 255.0/255.0, blue: 33.0/255.0, alpha: 1.0)
    }
    class func getBackSideArrrowColor() -> UIColor {
        return self.init(red: 212.0/255.0, green: 219.0/255.0, blue: 40.0/255.0, alpha: 1.0)
    }
}
