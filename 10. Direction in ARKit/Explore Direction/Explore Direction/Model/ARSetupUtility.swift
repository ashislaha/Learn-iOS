//
//  ARUtility.swift
//  Explore Direction
//
//  Created by Ashis Laha on 14/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import ARKit

@available(iOS 11.0, *)
final class ARSetupUtility : NSObject {
    
    static var shared = ARSetupUtility()
    private override init(){}
    
    private var paths : [CLLocationCoordinate2D] = []
    private var destination : CLLocationCoordinate2D?
    private var polyline : GMSPolyline?
    
    // get angle
    public func getAngle(location1 : CLLocationCoordinate2D, location2 : CLLocationCoordinate2D) -> Double {
        let dx = location2.longitude - location1.longitude
        let dy = location2.latitude - location1.latitude
        var theta = 0.0
        
        if dx == 0 && dy == 0 { // same location then show the arrow down-wards , like car location
            theta = Double.pi/2
        } else {
            
            theta += atan(Double(dy/dx))
            if dx < 0 && dy < 0 { // 3rd co-ordinate where tan is +ve
                theta += Double.pi
            } else if dx < 0 && dy > 0 { // 2nd coordinate where tan is -ve
                theta += Double.pi
            }
            if theta == .nan {
                theta = 3.14159265358979 / 2 // 90 Degree
            }
        }
        
        print("\n\n\nprev : \(location1)")
        print("next : \(location2)")
        print("dx = \(dx) and dy =\(dy) Angle: \(theta * 180 / Double.pi) ")
        return theta
    }
    
    // rotate node
    public func rotateNode(node : SCNNode, theta : Double, with animation : Bool = false) {
        if animation {
            let rotation = CABasicAnimation(keyPath: "rotation")
            rotation.fromValue = SCNVector4Make(0, 1, 0, 0)
            rotation.toValue = SCNVector4Make(0, 1, 0,  Float(theta))
            rotation.duration = 2.0
            node.addAnimation(rotation, forKey: "Rotate it")
        }
        node.rotation = SCNVector4Make(0, 1, 0, Float(theta))
    }
    
    public func rotateDownwardsNode(node : SCNNode, theta : Double, with animation : Bool = false) {
        if animation {
            let rotation = CABasicAnimation(keyPath: "rotation")
            rotation.fromValue = SCNVector4Make(0, 0, 1, 0)
            rotation.toValue = SCNVector4Make(0, 0, 1, Float(theta))
            rotation.duration = 2.0
            node.addAnimation(rotation, forKey: "Rotate it")
        }
        node.rotation = SCNVector4Make(0,0,1, Float(theta))
    }
    
    // add gradient effect
    public func addGradientEffect(node : SCNNode) {
        
        let startLocations : [NSNumber] = [0.0, 0.5, 1.0]
        let endLocations : [NSNumber] =  [0.5, 0.75, 1.0]
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
        gradient.locations = startLocations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.7)
        
     
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startLocations
        animation.toValue = endLocations
        animation.autoreverses = true
        animation.repeatCount = .infinity
        gradient.add(animation, forKey: "animateGradient")
        node.addAnimation(animation, forKey: "gradient it")
    }
    
    public func contentAnimationChange(node : SCNNode) {
        // shimmer animation
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3.0
        
        let easeInEaseOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        SCNTransaction.animationTimingFunction = easeInEaseOut
        
        SCNTransaction.completionBlock = {
            self.contentAnimationChange(node: node)
        }
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.getRandomColor()
        SCNTransaction.commit()
    }
    
    // Get Input
    public func getInput(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D, mapView : GMSMapView, completionBlock : (([CLLocationCoordinate2D])->())?) {
        self.destination = nil
        self.paths = []
        
        self.destination = destination
        drawPath(source: source, destination: destination, map: mapView) { [weak self] (pathMatrix) in
            
            //guard let pathMatrix = pathMatrix as? [CLLocationCoordinate2D] else { return }
            self?.paths = pathMatrix
            completionBlock?(pathMatrix)
        }
    }
    
    //get polyline
    public func getPolylinePoints(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D, completionBlock: (([CLLocationCoordinate2D])->())?) {
        computePath(source: source, destination: destination) { [weak self] (path) in
            guard let path = path as? GMSPath else { return }
            self?.polyline = GMSPolyline(path: path)
            
            if let polyline = self?.polyline {
                // compute path matrix
                self?.computePathMatrix(polyline: polyline,completionBlock:completionBlock)
            }
        }
    }
    
    // open AR view
    private func openARView() -> ARViewController? {
        guard !paths.isEmpty, let arVC = UIStoryboard(name: Constants.storyboardName, bundle: nil).instantiateViewController(withIdentifier: "ARViewController") as? ARViewController else { return nil }
        
        let model = OlaLensModel()
        model.carLocation = destination
        model.sectionCoordinates = paths
        model.carRegisterNumber = "KA00421L"
        model.carNumber = "0045"
        arVC.model = model
        //self.present(arVC, animated: true, completion: nil)
        return arVC
    }
    
    // Draw Path on Map
    private func drawPath(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D, map : GMSMapView, completionBlock : (([CLLocationCoordinate2D])->())?) {
        
        // calculate path
        computePath(source: source, destination: destination) { [weak self] (path) in
            guard let path = path as? GMSPath else { return }
            
            //show path
            self?.polyline?.map = nil
            self?.polyline = GMSPolyline(path: path)
            
            if let polyline = self?.polyline {
                self?.showPath(path:path, map: map, polylineRef: polyline)
                // compute path matrix
                self?.computePathMatrix(polyline: polyline,completionBlock:completionBlock)
            }
        }
    }
    
    private func showPath(path : GMSPath, map : GMSMapView, polylineRef : GMSPolyline) {
        polylineRef.path = path
        polylineRef.strokeColor = UIColor.blue
        polylineRef.strokeWidth = 5
        polylineRef.map = map
    }
    
    // Compute Path
    private func computePath(source : CLLocationCoordinate2D , destination : CLLocationCoordinate2D, completionBlock: ((Any)->())?) {
        
        fetchRoute(source: source, destination: destination, completionHandler: { (polyline) in
            
            if let polyline = polyline as? GMSPolyline {
                // Add source to PATH
                let path = GMSMutablePath()
                path.add(source)
                
                // add rest of the co-ordinates of polyline
                if let polyLinePath = polyline.path, polyLinePath.count() > 0 {
                    for i in 0..<polyLinePath.count() {
                        path.add(polyLinePath.coordinate(at: i))
                    }
                }
                completionBlock?(path)
            }
        })
    }
    
    // Fetch Route
    private func fetchRoute(source : CLLocationCoordinate2D, destination : CLLocationCoordinate2D , completionHandler : ((Any) -> ())? ) {
        let origin = String(format: "%f,%f", source.latitude,source.longitude)
        let destination = String(format: "%f,%f", destination.latitude,destination.longitude)
        let directionsAPI = "https://maps.googleapis.com/maps/api/directions/json?"
        let directionsUrlString = String(format: "%@&origin=%@&destination=%@&mode=walking",directionsAPI,origin,destination ) // walking , driving
        
        if let url = URL(string: directionsUrlString) {
            
            let fetchDirection = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                DispatchQueue.main.async {
                    if error == nil && data != nil {
                        var polyline : GMSPolyline?
                        if let dictionary = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments ) as? [String : Any] {
                            if let routesArray = dictionary?["routes"] as? [Any], !routesArray.isEmpty {
                                if let routeDict = routesArray.first as? [String : Any] , !routeDict.isEmpty {
                                    if let routeOverviewPolyline = routeDict["overview_polyline"] as? [String : Any] , !routeOverviewPolyline.isEmpty {
                                        if let points = routeOverviewPolyline["points"] as? String {
                                            if let path = GMSPath(fromEncodedPath: points) {
                                                polyline = GMSPolyline(path: path)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if let polyline = polyline { completionHandler?(polyline) }
                    }
                }
            })
            fetchDirection.resume()
        }
    }
    
    // Compute Path Matrix
    private func computePathMatrix(polyline : GMSPolyline, completionBlock: (([CLLocationCoordinate2D])->())? ) {
        var pathMatrix : [CLLocationCoordinate2D] = []
        
        if let path = polyline.path {
            var polylinePath : [CLLocationCoordinate2D] = []
            for i in 0..<path.count() {
                let point = path.coordinate(at: i)
                polylinePath.append(point)
            }
            pathMatrix = polylinePath
        }
        completionBlock?(pathMatrix)
    }
}

