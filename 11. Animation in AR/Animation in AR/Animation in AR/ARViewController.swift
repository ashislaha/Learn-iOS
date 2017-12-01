//
//  ViewController.swift
//  Animation in AR
//
//  Created by Ashis Laha on 25/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import ARKit

class ARViewController: UIViewController {

    private var rootNode : SCNNode!
    private let arrowSceneName = "art.scnassets/arrow.scn"
    
    // scene view
    private let sceneView : SceneView = {
        let sceneView = SceneView()
        sceneView.translatesAutoresizingMaskIntoConstraints = false // enable auto-layout
        return sceneView
    }()
    
    // layout setup
    private func layoutSetUp() {
        view.addSubview(sceneView) // add to view hierarchy
        
        sceneView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        NSLayoutConstraint.activate([
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
   
    
    //MARK: view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Basics of ARKit"
        layoutSetUp()
        sceneView.delegate = self           // ARSCNViewDelegate
        sceneView.session.delegate = self   // ARSessionDelegate
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        sceneView.pause()
    }

    //MARK: add node
    private func addTextNodes() {
        let textNode = SCNNode()
        textNode.addChildNode(NodeCreator.create3DText("Ashis", position: SCNVector3Make(0, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Pushpak", position: SCNVector3Make(0.5, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Nihar", position: SCNVector3Make(1, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Himanshu", position: SCNVector3Make(1.5, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Abhra", position: SCNVector3Make(-0.5, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Deepanshu", position: SCNVector3Make(-1.0, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Dheeraj", position: SCNVector3Make(-1.5, 0, -0.5)))
        textNode.addChildNode(NodeCreator.create3DText("Arnav", position: SCNVector3Make(-2.0, 0, -0.5)))
        rootNode?.addChildNode(textNode)
    }
    
    private func addArrowNode() {
        let arrow = NodeCreator.getArrow(sceneName: arrowSceneName)
        arrow.childNodes[0].geometry?.firstMaterial?.diffuse.contents = UIColor.getBackSideArrrowColor
        arrow.childNodes[1].geometry?.firstMaterial?.diffuse.contents = UIColor.getFrontSideArrowColor
        arrow.position = SCNVector3Make(0, 0, -0.4)
        rootNode.addChildNode(arrow)
        //rotateNode(node: arrow, theta: Double.pi, with: false) // basic animation
        //moveUpDown(node: arrow)
        addTexture(node: arrow,backward: true)
        //rotateUsingTransaction(node: arrow, theta: Double.pi)
    }
    
    //MARK: Do animation
    
    // (2). addTexture using SCNAction
    private func addTexture(node : SCNNode, backward : Bool = false) {
        let toPow: Double = 3
        let timeDuration: Double = 15 / pow(2, toPow)
        let textureAction = SCNAction.customAction(duration: timeDuration) { (node, d) in
            let num = Int(Double(d) * pow(2, toPow)) + 1
            let imgName = backward ? "b\(num)" : "f\(num)"
            node.rotation = backward ? SCNVector4Make(0, 1, 0, Float(Double.pi)) : SCNVector4Make(0, 1, 0, 0)
            if let image = UIImage(named: imgName) {
                let material1 = SCNMaterial()
                material1.diffuse.contents = image
                
                let material2 = SCNMaterial()
                material2.diffuse.contents = UIColor.getFrontSideArrowColor()
                
                node.childNodes[0].geometry?.firstMaterial = material1
                node.childNodes[1].geometry?.firstMaterial = material2
            }
        }
        let repeatAction = SCNAction.repeatForever(textureAction)
        node.runAction(repeatAction)
    }
    
    
    // (1). CAAnimation
    private func rotateNode(node : SCNNode, theta : Double, with animation : Bool = false) {
        if animation {
            let rotation = CABasicAnimation(keyPath: "rotation")
            rotation.fromValue = SCNVector4Make(0,1,0,0) // along x-z plane
            rotation.toValue = SCNVector4Make(0,1,0,Float(theta))
            rotation.duration = 5.0
            node.addAnimation(rotation, forKey: "Rotate it")
        }
        node.rotation = SCNVector4Make(0, 1, 0, Float(theta))  // along x-z plane
    }
    
    // (2). SCNAction
    private func moveUpDown(node : SCNNode) {
        let moveUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 1)
        moveUp.timingMode = .easeInEaseOut
        let moveDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 1)
        moveDown.timingMode = .easeInEaseOut
        let moveSequence = SCNAction.sequence([moveUp,moveDown])
        let moveLoop = SCNAction.repeatForever(moveSequence)
        node.runAction(moveLoop)
    }
    
    // (3). SCNTransaction
    private func rotateUsingTransaction(node : SCNNode, theta : Double) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 5.0
        node.rotation = SCNVector4Make(0, 1, 0, Float(theta))
        SCNTransaction.completionBlock = {
            print("Transaction completed")
        }
        SCNTransaction.commit()
    }
    
}

//MARK: ARSCNViewDelegate
extension ARViewController : ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didRenderScene scene: SCNScene, atTime time: TimeInterval) {
        if rootNode == nil { // this is one time execution
            rootNode = SCNNode()
            scene.rootNode.addChildNode(rootNode)
            //addTextNodes()
           addArrowNode()
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
    
    fileprivate func showAlert(header : String? = "Header", message : String? = "Message")  {
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
        return self.init(red: 239.0/255.0, green: 255.0/255.0, blue: 33.0/255.0, alpha: 1.0)
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
