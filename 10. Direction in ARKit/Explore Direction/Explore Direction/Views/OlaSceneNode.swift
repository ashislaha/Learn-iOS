//
//  OlaSceneNode.swift
//  Explore Direction
//
//  Created by Ashis Laha on 14/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import ARKit
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

@available(iOS 11.0, *)
class OlaSceneNode : LocationAnnotationNode  { 
    
    let sceneName = "art.scnassets/arrow.scn"
    
    public init(location: CLLocation?, downArrow : Bool = false, backward : Bool = false) {
        super.init(location: location, image: UIImage())
        super.constraints = [] // remove the Y-axis billboard constraint from super
        
        let annotationNode = ARSetupUtility.shared.getArrow3D(sceneName: sceneName, downArrow : downArrow)
        self.location = location
        addChildNode(annotationNode)
        ARSetupUtility.shared.addTexture(node: annotationNode, backward : backward)
    }
    
    public override init(location: CLLocation?, image: UIImage) {
        super.init(location: location, image: image)
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIColor {
    class func getFrontSideArrowColor() -> UIColor {
        return self.init(red: 237.0/255.0, green: 252.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    }
    class func getBackSideArrrowColor() -> UIColor {
        return self.init(red: 212.0/255.0, green: 219.0/255.0, blue: 40.0/255.0, alpha: 1.0)
    }
    class func getCustomColor() -> UIColor {
        return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.8)
    }
}

