//
//  OlaSceneNode.swift
//  Explore Direction
//
//  Created by Ashis Laha on 14/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import ARKit
import ARCL
import CoreLocation

class OlaSceneNode : LocationAnnotationNode  { 
    
    public init(location: CLLocation?) {
        super.init(location: location, image: UIImage())
        super.constraints = [] // remove the Y-axis billboard constraint from super
        
        let annotationNode = getArrow3D(sceneName: "art.scnassets/arrow.scn")
        self.location = location
        addChildNode(annotationNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getArrow3D(sceneName : String) -> SCNNode {
        guard let scene = SCNScene(named:sceneName) else { return SCNNode() }
        if scene.rootNode.childNodes.count == 2 {
            scene.rootNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
            scene.rootNode.childNodes[1].geometry?.firstMaterial?.diffuse.contents = UIColor.getBackSideArrrowColor()
        } else {
            for each in scene.rootNode.childNodes {
                each.geometry?.firstMaterial?.diffuse.contents = UIColor.getFontSideArrowColor()
            }
        }
        scene.rootNode.scale = SCNVector3Make(3, 3, 3)
        return scene.rootNode
    }
    
    private func addShimmerAnimationForLifeTime(node : SCNNode) {
        // shimmer animation
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 3.0
        
        let easeInEaseOut = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        SCNTransaction.animationTimingFunction = easeInEaseOut
        
        SCNTransaction.completionBlock = {
            self.addShimmerAnimationForLifeTime(node: node)
        }
        //node.geometry?.firstMaterial?.diffuse.contents =  UIImage.getRandomImages()
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.getRandomColor()
        SCNTransaction.commit()
    }
}

extension UIColor {
    class func getCustomColor() -> UIColor {
        return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.8)
    }
    
    
    class func getRandomColor() -> UIColor {
        let random = Int(arc4random_uniform(8))
        switch random {
        case 0: return UIColor.red
        case 1: return UIColor.brown
        case 2: return UIColor.green
        case 3: return UIColor.yellow
        case 4: return UIColor.blue
        case 5: return UIColor.purple
        case 6: return UIColor.cyan
        case 7: return UIColor.orange
        default: return UIColor.darkGray
        }
    }
    
    class func getOlacabColor() -> UIColor {
        let random = Int(arc4random_uniform(5))
        switch random {
        case 0: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.75)
        case 1: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.7)
        case 2: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.95)
        case 3: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.8)
        case 4: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 1.0)
        default: return self.init(red: 239.0/255.0, green: 253.0/255.0, blue: 65.0/255.0, alpha: 0.8)
        }
    }
    
}

