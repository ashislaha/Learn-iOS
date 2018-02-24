//
//  ARViewModel.swift
//  Explore Direction
//
//  Created by Ashis Laha on 25/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreLocation

@available(iOS 11.0, *)
class ARViewModel {
    
    // add a NSCache for caching the images
    private let cacheImages = NSCache<NSString, UIImage>()
    
    
    // get all scene nodes
    func getSceneNodes(model: OlaLensModel?) -> [OlaSceneNode] {
        
        guard let sectionCoordinates = model?.sectionCoordinates, let endPosition = model?.carLocation , let appDelegate = UIApplication.shared.delegate as? AppDelegate, let userLocation = appDelegate.locationManager.location?.coordinate , !sectionCoordinates.isEmpty else { return [] }
        
        var nodes: [OlaSceneNode] = []
        var prevLocation : CLLocationCoordinate2D = userLocation
        if let node = getOlaLensNode(location: prevLocation,previousLocation: sectionCoordinates.first!) {
            nodes.append(node)
        }
        
        for location in sectionCoordinates where ARSetupUtility.shared.distanceMore(location1: prevLocation, location2: location, limit: 10) {
            if let node = getOlaLensNode(location: location,previousLocation: prevLocation) {
                nodes.append(node)
            }
            prevLocation = location
        }
        // at car position
        if let node = getOlaLensNode(location: endPosition, previousLocation: prevLocation,imageName: "logo") {
            nodes.append(node)
        }
        if let node = getOlaLensNode(location: endPosition, previousLocation: endPosition,imageName: "", downwards: true) {
            nodes.append(node)
        }
        
        return nodes
    }
    
    /* There are 2 types of sceneNode:
     (1). Node contains a 2-D image and it's billboard constraint along Y axis is always true so that it will always focus to camera.
     (2). Node contains a 3-D Arrow Asset.
     */
    
    private func getOlaLensNode(location: CLLocationCoordinate2D, previousLocation: CLLocationCoordinate2D, imageName: String = "" , downwards: Bool = false) -> OlaSceneNode? {
        guard let altitude = getLocationAltitude() else { return nil}
        
        if let image = UIImage(named: imageName) {
            let altitudeMatric = altitude + 1.8
            let nodeLocation = CLLocation(coordinate: location, altitude: altitudeMatric)
            let node = OlaSceneNode(location: nodeLocation, image: image)
            node.scale = SCNVector3Make(3, 3, 3)
            node.scaleRelativeToDistance = true
            return node
        } else {
            let nodeLocation = CLLocation(coordinate: location, altitude: altitude)
            var node : OlaSceneNode!
            if !downwards {
                let theta = ARSetupUtility.shared.getAngle(location1: previousLocation, location2: location)
                let backward = theta <= Double.pi/2 || theta <= -Double.pi/2 ? false : true
                
                node = OlaSceneNode(location: nodeLocation, downArrow: downwards, backward: backward)
                node.scaleRelativeToDistance = true
                ARSetupUtility.shared.rotateNode(node: node, theta: theta)
            } else {
                
                node = OlaSceneNode(location: nodeLocation, downArrow: downwards)
                node.scaleRelativeToDistance = true
                
                let billboardConstraint = SCNBillboardConstraint()
                billboardConstraint.freeAxes = .Y
                node.constraints = [billboardConstraint] // make it focus to camera always
            }
            return node
        }
    }
    
    private func getLocationAltitude() -> CLLocationDistance? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.locationManager.location?.altitude
    }
    
    // get car image
    func getCarImage(urlString : String?, completionBlock: @escaping (UIImage?)->()) {
        guard let urlString = urlString, let url = URL(string: urlString), !urlString.isEmpty else { return }
        
        // check whether the image is present into cache or not
        if let image = cacheImages.object(forKey: NSString(string: urlString)) {
            completionBlock(image)
        } else {
            let session = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data , error == nil else { return }
                guard let image = UIImage(data: data) else { return }
                self?.cacheImages.setObject(image, forKey: NSString(string: urlString)) // setting into cache
                completionBlock(image)
            }
            session.resume()
        }
    }
}
