//
//  LocationNode.swift
//  Explore Direction
//
//  Created by Ashis Laha on 11/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation

@available(iOS 11.0, *)
open class LocationNode: SCNNode {
    
    public var location: CLLocation!
    public var locationConfirmed = false
    public var continuallyAdjustNodePositionWhenWithinRange = true
    public var continuallyUpdatePositionAndScale = true
    
    public init(location: CLLocation?) {
        self.location = location
        self.locationConfirmed = location != nil
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@available(iOS 11.0, *)
open class LocationAnnotationNode: LocationNode {
    public let image: UIImage
    public let annotationNode: SCNNode
    public var scaleRelativeToDistance = false
    
    public init(location: CLLocation?, image: UIImage) {
        self.image = image
        
        let plane = SCNPlane(width: image.size.width / 100, height: image.size.height / 100)
        plane.firstMaterial?.diffuse.contents = image
        plane.firstMaterial?.lightingModel = .constant
        annotationNode = SCNNode()
        annotationNode.geometry = plane
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        addChildNode(annotationNode)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
