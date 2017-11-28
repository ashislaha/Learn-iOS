//
//  Extensions.swift
//  Explore Direction
//
//  Created by Ashis Laha on 11/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import SceneKit
import CoreLocation

class SceneLocationEstimate {
    let location: CLLocation
    let position: SCNVector3
    
    init(location: CLLocation, position: SCNVector3) {
        self.location = location
        self.position = position
    }
}

// Translation in meters between 2 locations
public struct LocationTranslation {
    public var latitudeTranslation: Double
    public var longitudeTranslation: Double
    public var altitudeTranslation: Double
    
    public init(latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) {
        self.latitudeTranslation = latitudeTranslation
        self.longitudeTranslation = longitudeTranslation
        self.altitudeTranslation = altitudeTranslation
    }
}

public extension CLLocation {
    public convenience init(coordinate: CLLocationCoordinate2D, altitude: CLLocationDistance) {
        self.init(coordinate: coordinate, altitude: altitude, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: Date())
    }
    
    // Translates distance in meters between two locations.
    // Returns the result as the distance in latitude and distance in longitude.
    
    public func translation(toLocation location: CLLocation) -> LocationTranslation {
        
        let inbetweenLocation = CLLocation(latitude: self.coordinate.latitude, longitude: location.coordinate.longitude)
        let distanceLatitude = location.distance(from: inbetweenLocation)
        let latitudeTranslation: Double
        latitudeTranslation = location.coordinate.latitude > inbetweenLocation.coordinate.latitude ? distanceLatitude : (0 - distanceLatitude)
        
        let distanceLongitude = self.distance(from: inbetweenLocation)
        let longitudeTranslation: Double
        
        longitudeTranslation = self.coordinate.longitude > inbetweenLocation.coordinate.longitude ? (0 - distanceLongitude) : distanceLongitude
        let altitudeTranslation = location.altitude - self.altitude
        
        return LocationTranslation(latitudeTranslation: latitudeTranslation,longitudeTranslation: longitudeTranslation,altitudeTranslation: altitudeTranslation)
    }
    
    public func translatedLocation(with translation: LocationTranslation) -> CLLocation {
        
        let latitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 0, distanceMeters: translation.latitudeTranslation)
        let longitudeCoordinate = self.coordinate.coordinateWithBearing(bearing: 90, distanceMeters: translation.longitudeTranslation)
        let coordinate = CLLocationCoordinate2D(latitude: latitudeCoordinate.latitude,longitude: longitudeCoordinate.longitude)
        let altitude = self.altitude + translation.altitudeTranslation
        
        return CLLocation(coordinate: coordinate, altitude: altitude, horizontalAccuracy: self.horizontalAccuracy, verticalAccuracy: self.verticalAccuracy, timestamp: self.timestamp)
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

public extension FloatingPoint {
    public var degreesToRadians: Self { return self * .pi / 180 }
    public var radiansToDegrees: Self { return self * 180 / .pi }
}

extension Double {
    func metersToLatitude() -> Double {
        return self / (6360500.0)
    }
    
    func metersToLongitude() -> Double {
        return self / (5602900.0)
    }
}

public extension CLLocationCoordinate2D {
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

extension SceneLocationEstimate {
    // Compares the location's position to another position, to determine the translation between them
    func locationTranslation(to position: SCNVector3) -> LocationTranslation {
        return LocationTranslation(
            latitudeTranslation: Double(self.position.z - position.z),
            longitudeTranslation: Double(position.x - self.position.x),
            altitudeTranslation: Double(position.y - self.position.y))
    }
    
    // Translates the location by comparing with a given position
    func translatedLocation(to position: SCNVector3) -> CLLocation {
        let translation = self.locationTranslation(to: position)
        let translatedLocation = self.location.translatedLocation(with: translation)
        
        return translatedLocation
    }
}

@available(iOS 11.0, *)
extension SCNNode {
    class func axesNode(quiverLength: CGFloat, quiverThickness: CGFloat) -> SCNNode {
        let quiverThickness = (quiverLength / 50.0) * quiverThickness
        let chamferRadius = quiverThickness / 2.0
        
        let xQuiverBox = SCNBox(width: quiverLength, height: quiverThickness, length: quiverThickness, chamferRadius: chamferRadius)
        xQuiverBox.firstMaterial?.diffuse.contents = UIColor.red
        let xQuiverNode = SCNNode(geometry: xQuiverBox)
        xQuiverNode.position = SCNVector3Make(Float(quiverLength / 2.0), 0.0, 0.0)
        
        let yQuiverBox = SCNBox(width: quiverThickness, height: quiverLength, length: quiverThickness, chamferRadius: chamferRadius)
        yQuiverBox.firstMaterial?.diffuse.contents = UIColor.green
        let yQuiverNode = SCNNode(geometry: yQuiverBox)
        yQuiverNode.position = SCNVector3Make(0.0, Float(quiverLength / 2.0), 0.0)
        
        let zQuiverBox = SCNBox(width: quiverThickness, height: quiverThickness, length: quiverLength, chamferRadius: chamferRadius)
        zQuiverBox.firstMaterial?.diffuse.contents = UIColor.blue
        let zQuiverNode = SCNNode(geometry: zQuiverBox)
        zQuiverNode.position = SCNVector3Make(0.0, 0.0, Float(quiverLength / 2.0))
        
        let quiverNode = SCNNode()
        quiverNode.addChildNode(xQuiverNode)
        quiverNode.addChildNode(yQuiverNode)
        quiverNode.addChildNode(zQuiverNode)
        quiverNode.name = "Axes"
        return quiverNode
    }
}

@available(iOS 11.0, *)
extension SCNVector3 {
    // Calculates distance between vectors
    // Doesn't include the y axis, matches functionality of CLLocation 'distance' function.
    func distance(to anotherVector: SCNVector3) -> Float {
        return sqrt(pow(anotherVector.x - x, 2) + pow(anotherVector.z - z, 2))
    }
}

