//
//  OlaLensNode.swift
//  Explore Direction
//
//  Created by Ashis Laha on 17/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import CoreLocation
import ARKit

// Keep the location traslation information of each scene node
struct LocationTranslation {
    public var latitudeTranslation: Double
    public var longitudeTranslation: Double
    public var altitudeTranslation: Double
    
    public init(latitudeTranslation: Double, longitudeTranslation: Double, altitudeTranslation: Double) {
        self.latitudeTranslation = latitudeTranslation
        self.longitudeTranslation = longitudeTranslation
        self.altitudeTranslation = altitudeTranslation
    }
}

// combining core location and scene position
class SceneLocationEstimate {
    let location: CLLocation
    let position: SCNVector3
    
    init(location: CLLocation, position: SCNVector3) {
        self.location = location
        self.position = position
    }
}

// scene node
class OlaLensNode : SCNNode {
    
    var estimate : SceneLocationEstimate!
    private let arrow = "art.scnassets/arrow.scn"
    
    override init() {
        super.init()
    }
    
    init(location : CLLocation, image : UIImage?, downArrow : Bool = false) {
        super.init()
        
        guard let currentLocation = currentLocation() else { return }
        let currentPosition = getCurrentPosition()
        
        let locationTranslation = currentLocation.translation(toLocation: location) // translate
        let position = SCNVector3(
            x: currentPosition.x + Float(locationTranslation.longitudeTranslation),
            y: currentPosition.y + Float(locationTranslation.altitudeTranslation),
            z: currentPosition.z - Float(locationTranslation.latitudeTranslation))
        estimate = SceneLocationEstimate(location: location, position: position)
        
        if let image = image {
            let plane = SCNPlane(width: image.size.width / 100, height: image.size.height / 100)
            plane.firstMaterial!.diffuse.contents = image
            plane.firstMaterial!.lightingModel = .constant
            
            let childNode = SCNNode()
            childNode.geometry = plane
            childNode.position = position
            childNode.scale = SCNVector3Make(1, 1, 1)
            
            // A constraint that orients a node to always point toward the current camera
            let billboardConstraint = SCNBillboardConstraint()
            billboardConstraint.freeAxes = SCNBillboardAxis.Y
            childNode.constraints = [billboardConstraint]
            
            addChildNode(childNode)
        } else {
            
            let childNode = getArrow3D(sceneName: arrow,downArrow: downArrow)
            childNode.position = position
            childNode.scale = SCNVector3Make(2, 2, 2)
            addChildNode(childNode)
            addTexture(node: childNode)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func currentLocation() -> CLLocation? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate , let userLocation = appDelegate.locationManager.location else { return nil }
        return userLocation
    }
    
    private func getCurrentPosition() -> SCNVector3 { return SCNVector3Make(0, 0, 0) }
    
    private func getArrow3D(sceneName : String, downArrow : Bool = false) -> SCNNode {
        guard let scene = SCNScene(named:sceneName) else { return SCNNode() }
        if scene.rootNode.childNodes.count == 2 {
            scene.rootNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
            scene.rootNode.childNodes[1].geometry?.firstMaterial?.diffuse.contents = UIColor.getBackSideArrrowColor()
        } else {
            for each in scene.rootNode.childNodes {
                each.geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
            }
        }
        if downArrow {
            scene.rootNode.rotation = SCNVector4Make(0, 0, 1, -Float(Double.pi/2))
        }
        return scene.rootNode
    }
    
    private func addTexture(node : SCNNode) {
        let toPow: Double = 5
        let timeDuration: Double = 15 / pow(2, toPow)
        let textureAction = SCNAction.customAction(duration: timeDuration) { (node, d) in
            let imgName = "progressbar" + "\(Int(Double(d) * pow(2, toPow)) + 1)"
            //print(imgName)
            let image = UIImage(named: imgName)
            node.childNodes[0].geometry?.firstMaterial?.diffuse.contents = image
            node.childNodes[1].geometry?.firstMaterial?.diffuse.contents = image
        }
        let repeatAction = SCNAction.repeatForever(textureAction)
        node.runAction(repeatAction)
    }
}

// Scene View
class OlaSceneView: ARSCNView {
  
    private static let sceneDistanceLimit = 50.0
    private var updateEstimatesTimer: Timer?
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func run() {
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        session.run(configuration)
        
        //updateEstimatesTimer?.invalidate()
        //updateEstimatesTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(OlaSceneView.updateLocationData), userInfo: nil, repeats: true)
    }
    
    public func pause() {
        session.pause()
        updateEstimatesTimer?.invalidate()
        updateEstimatesTimer = nil
    }
    
    public func resetConfig() {
        if let config = session.configuration {
            session.run(config, options: .resetTracking)
        }
        run()
    }
    
    public func clearAR() {
        scene =  SCNScene() // assign an empty scene
        resetConfig()
    }
    
    @objc private func updateLocationData() {
        //removeOldLocationEstimates()
        //updatePositionAndScaleOfLocationNodes()
    }
}
