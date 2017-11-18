//
//  Utils.swift
//  Explore Direction
//
//  Created by Ashis Laha on 18/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation


// Scene Location View
//    private var sceneLocationView : SceneLocationView = {
//        let sceneLocationView = SceneLocationView()
//        sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
//        sceneLocationView.orientToTrueNorth = true
//        return sceneLocationView
//    }()


//class OlaLensLocationNode: SCNNode {
//
//    public var location: CLLocation!
//    public var locationConfirmed = false
//    public var continuallyAdjustNodePositionWhenWithinRange = true
//    public var continuallyUpdatePositionAndScale = true
//
//    public init(location: CLLocation?) {
//        self.location = location
//        self.locationConfirmed = location != nil
//        super.init()
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class OlaLensLocationAnnotationNode: OlaLensLocationNode {
//
//    public let image: UIImage
//    public let annotationNode: SCNNode
//    public var scaleRelativeToDistance = false
//
//    public init(location: CLLocation?, image: UIImage) {
//        self.image = image
//
//        let plane = SCNPlane(width: image.size.width / 100, height: image.size.height / 100)
//        plane.firstMaterial!.diffuse.contents = image
//        plane.firstMaterial!.lightingModel = .constant
//
//        annotationNode = SCNNode()
//        annotationNode.geometry = plane
//
//        super.init(location: location)
//
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//        constraints = [billboardConstraint]
//
//        addChildNode(annotationNode)
//    }
//
//    required public init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class OlaLensSceneNode : OlaLensLocationAnnotationNode {
//
//    public init(location: CLLocation?) {
//        super.init(location: location, image: UIImage())
//
//        let annotationNode = getArrow3D(sceneName: "art.scnassets/arrow.scn") // create SceneNode
//        //addShimmerAnimationForLifeTime(node: annotationNode)
//        self.location = location
//
//        // A constraint that orients a node to always point toward the current camera
//        let billboardConstraint = SCNBillboardConstraint()
//        billboardConstraint.freeAxes = SCNBillboardAxis.Y
//        constraints = [billboardConstraint]
//        addChildNode(annotationNode)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func getArrow3D(sceneName : String) -> SCNNode {
//        guard let scene = SCNScene(named:sceneName) else { return SCNNode() }
//        if scene.rootNode.childNodes.count == 2 { // beacause arrow consista of 2 child nodes
//            scene.rootNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
//            scene.rootNode.childNodes[1].geometry?.firstMaterial?.diffuse.contents = UIColor.getBackSideArrrowColor()
//        } else {
//            for each in scene.rootNode.childNodes {
//                each.geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
//            }
//        }
//        scene.rootNode.scale = SCNVector3Make(3, 3, 3)
//        return scene.rootNode
//    }
//}







//// remove old locations estimates
//private func removeOldLocationEstimates() {
//    if let currentScenePosition = currentScenePosition() {
//        self.removeOldLocationEstimates(currentScenePosition: currentScenePosition)
//    }
//}
//private func removeOldLocationEstimates(currentScenePosition: SCNVector3) {
//    let currentPoint = CGPoint.pointWithVector(vector: currentScenePosition)
//
//    sceneLocationEstimates = sceneLocationEstimates.filter({
//        let point = CGPoint.pointWithVector(vector: $0.position)
//        let radiusContainsPoint = currentPoint.radiusContainsPoint(radius: CGFloat(OlaSceneView.sceneLimit), point: point)
//        if !radiusContainsPoint {
//            print("Node removed : \($0)")
//        }
//        return radiusContainsPoint
//    })
//}
//
//// update positions and scale node
//func updatePositionAndScaleOfLocationNodes() {
//    for locationNode in locationNodes {
//        if locationNode.continuallyUpdatePositionAndScale {
//            updatePositionAndScaleOfLocationNode(locationNode: locationNode, animated: true)
//        }
//    }
//}

//private func updatePositionAndScaleOfLocationNode(locationNode: OlaLensLocationNode, initialSetup: Bool = false, animated: Bool = false, duration: TimeInterval = 0.1) {
//
//    guard let currentPosition = currentScenePosition(), let currentLocation = currentLocation() else { return }
//
//    SCNTransaction.begin()
//    if animated {
//        SCNTransaction.animationDuration = duration
//    } else {
//        SCNTransaction.animationDuration = 0
//    }
//    let locationNodeLocation = locationOfLocationNode(locationNode)
//
//    let locationTranslation = currentLocation.translation(toLocation: locationNodeLocation) // translate
//    let adjustedDistance: CLLocationDistance
//    let distance = locationNodeLocation.distance(from: currentLocation)
//
//    if locationNode.locationConfirmed && (distance > OlaSceneView.sceneLimit || locationNode.continuallyAdjustNodePositionWhenWithinRange || initialSetup) {
//        if distance > OlaSceneView.sceneLimit {
//            let scale = 100 / Float(distance)
//            adjustedDistance = distance * Double(scale)
//
//            let adjustedTranslation = SCNVector3(
//                x: Float(locationTranslation.longitudeTranslation) * scale,
//                y: Float(locationTranslation.altitudeTranslation) * scale,
//                z: Float(locationTranslation.latitudeTranslation) * scale)
//
//            let position = SCNVector3(
//                x: currentPosition.x + adjustedTranslation.x,
//                y: currentPosition.y + adjustedTranslation.y,
//                z: currentPosition.z - adjustedTranslation.z)
//            locationNode.position = position
//            locationNode.scale = SCNVector3(x: scale, y: scale, z: scale)
//        } else {
//            adjustedDistance = distance
//            let position = SCNVector3(
//                x: currentPosition.x + Float(locationTranslation.longitudeTranslation),
//                y: currentPosition.y + Float(locationTranslation.altitudeTranslation),
//                z: currentPosition.z - Float(locationTranslation.latitudeTranslation))
//            locationNode.position = position
//            locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//        }
//    } else {
//        //Calculates distance based on the distance within the scene, as the location isn't yet confirmed
//        adjustedDistance = Double(currentPosition.distance(to: locationNode.position))
//        locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//    }
//
//    if let annotationNode = locationNode as? OlaLensLocationAnnotationNode {
//
//        let appliedScale = locationNode.scale
//        locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//        var scale: Float
//
//        if annotationNode.scaleRelativeToDistance { // relative to dist
//            scale = appliedScale.y
//            annotationNode.annotationNode.scale = appliedScale
//        } else { //Scale it to be an appropriate size so that it can be seen
//            scale = Float(adjustedDistance) * 0.181
//            if distance > 3000 { scale = scale * 0.75 }
//            annotationNode.annotationNode.scale = SCNVector3(x: scale, y: scale, z: scale)
//        }
//
//        annotationNode.pivot = SCNMatrix4MakeTranslation(0, -1.1 * scale, 0)
//    }
//
//    SCNTransaction.commit()
//}
//
//private func currentLocation() -> CLLocation? {
//    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate , let userLocation = appDelegate.locationManager.location else { return nil }
//    return userLocation
//}
//
//private func locationOfLocationNode(_ locationNode: OlaLensLocationNode) -> CLLocation {
//    return locationNode.location!
//}



// scene view
//    private var sceneView : SceneLocationView = {
//        let sceneView = SceneLocationView()
//        sceneView.orientToTrueNorth = true
//        sceneView.translatesAutoresizingMaskIntoConstraints = false
//        return sceneView
//    }()

/*
 // While using SceneLocationView
 private func addOlaLensNode(location : CLLocationCoordinate2D, previousLocation : CLLocationCoordinate2D, imageName : String = "" ) {
 guard let altitude = getLocationAltitude() else { return }
 
 let nodeLocation = CLLocation(coordinate: location, altitude: altitude)
 if let image = UIImage(named: imageName) {
 let node =  LocationAnnotationNode(location: nodeLocation, image: image)
 node.scaleRelativeToDistance = true
 sceneView.addLocationNodeWithConfirmedLocation(locationNode: node)
 
 } else {
 let node = OlaSceneNode(location: nodeLocation)
 node.scaleRelativeToDistance = true
 //let theta = ARSetupUtility.shared.getAngle(location1: previousLocation, location2: location)
 //ARSetupUtility.shared.rotateNode(node: node, theta: theta)
 sceneView.addLocationNodeWithConfirmedLocation(locationNode: node)
 }
 }
 */





