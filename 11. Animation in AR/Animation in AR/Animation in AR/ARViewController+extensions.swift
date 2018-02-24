//
//  ARViewController+extensions.swift
//  Animation in AR
//
//  Created by Ashis Laha on 25/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit
import ARKit

//MARK: ARSCNViewDelegate
extension ARViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if rootNode == nil { // this is one time execution
            rootNode = SCNNode()
            scene.rootNode.addChildNode(rootNode)
            //addTextNodes()
            //addArrowNode()
            twoNodesExperiment()
        }
    }
}

//MARK: ARSessionDelegate
extension ARViewController : ARSessionDelegate {
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        showAlert(header: "Session Failure", message: "\(error.localizedDescription)")
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        showAlert(header: "Session Failure", message: "Session Was Interrupted")
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        showAlert(header: "Session Restore", message: "Session Interruption ended")
    }
}


// Error Handling pop up
extension ARViewController {
    
    func showAlert(header : String? = "Header", message : String? = "Message")  {
        let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIColor {
    class func getFrontSideArrowColor() -> UIColor {
        return self.init(red: 237.0/255.0, green: 252.0/255.0, blue: 41.0/255.0, alpha: 1.0)
    }
    class func getBackSideArrrowColor() -> UIColor {
        return self.init(red: 212.0/255.0, green: 219.0/255.0, blue: 40.0/255.0, alpha: 1.0)
    }
}

extension UIImage {
    
    static func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        let size = oldImage.size
        UIGraphicsBeginImageContext(size)
        
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(Double.pi / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        let origin = CGPoint(x: -size.width / 2, y: -size.width / 2)
        bitmap.draw(oldImage.cgImage!, in: CGRect(origin: origin, size: size))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
