//
//  ViewController.swift
//  Animation in AR
//
//  Created by Ashis Laha on 25/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import ARKit


enum GeometryType {
    case Box
    case Pyramid
    case Capsule
    case Cone
    case Cylinder
}

class ARViewController: UIViewController {

    var rootNode : SCNNode!
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
    func addTextNodes() {
        let textNode = SCNNode()
        textNode.addChildNode(NodeCreator.create3DText("Hello Hackathon", position: SCNVector3Make(0, 0.15, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Pushpak", position: SCNVector3Make(0.5, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Nihar", position: SCNVector3Make(1, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Himanshu", position: SCNVector3Make(1.5, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Abhra", position: SCNVector3Make(-0.5, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Deepanshu", position: SCNVector3Make(-1.0, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Dheeraj", position: SCNVector3Make(-1.5, 0, -0.5)))
//        textNode.addChildNode(NodeCreator.create3DText("Arnav", position: SCNVector3Make(-2.0, 0, -0.5)))
        rootNode?.addChildNode(textNode)
    }
    
    func addArrowNode() {
        let arrow = NodeCreator.getArrow(sceneName: arrowSceneName)
        arrow.position = SCNVector3Make(0, 0, -1)
        rootNode.addChildNode(arrow)
        
        //let theta = getAngle(dx: 1, dy: 11)
        rotateNode(node: arrow, theta: 2 * Double.pi, with: true) // basic animation
        let backward = false //theta <= Double.pi/2 || theta <= -Double.pi/2 ? false : true
        addTexture(node: arrow,backward: backward)
        print("animation direction backward = \(backward)")
        
        //moveUpDown(node: arrow)
        //rotateUsingTransaction(node: arrow, theta: theta)
    }

    func getGeometry(type: GeometryType) -> SCNGeometry {
        switch type {
        case .Box:          return SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.05)
        case .Pyramid:      return SCNPyramid(width: 0.2, height: 0.2, length: 0.2)
        case .Capsule:      return SCNCapsule(capRadius: 0.2, height: 0.1)
        case .Cone:         return SCNCone(topRadius: 0.0, bottomRadius: 0.2, height: 0.4)
        case .Cylinder:     return SCNCylinder(radius: 0.05, height: 0.2)
        }
    }
    
    func twoNodesExperiment() {
        
        // always focus on camera view
        let geometry1 : SCNGeometry! = getGeometry(type: .Pyramid)
        geometry1.firstMaterial?.diffuse.contents = UIColor.red
        let node1 = SCNNode(geometry: geometry1)
        node1.position = SCNVector3Make(0.4, 0, -0.5)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        node1.constraints = [billboardConstraint]
        rootNode.addChildNode(node1)
        
        // two nodes focusing each other
        let geometry2 = getGeometry(type: .Cylinder)
        geometry2.firstMaterial?.diffuse.contents = UIColor.green
        let node2 = SCNNode(geometry: geometry2)
        node2.position = SCNVector3Make(-0.1, 0, -0.5)

        let geometry3 = getGeometry(type: .Box)
        geometry3.firstMaterial?.diffuse.contents = UIColor.blue
        let node3 = SCNNode(geometry: geometry3)
        node3.position = SCNVector3Make(0.2, 0, -0.5)
        
        let lookAtConstraints = SCNLookAtConstraint(target: node3)
        node2.constraints = [lookAtConstraints]
        
        [node2, node3].forEach{ rootNode.addChildNode($0) }
    }
    
    //MARK: Do animation
    public func getAngle(dx: Double, dy: Double) -> Double {
        var theta = 0.0
        
        theta += atan(Double(dy/dx))
        print("tan-inverse theta: \(theta * 180 / Double.pi)")
        
        if dx < 0 && dy > 0 || dx < 0 && dy < 0 { // 2nd, 3rd coordinates, no need to add anything for 1st coordinate and 4th coordinates
            theta += Double.pi
        } else if theta == .nan && dy >= 0 { // dx = 0
            theta = Double.pi/2 // 90 Degree
        } else if theta == .nan && dy < 0 { // dx = 0
            theta = -Double.pi/2 // -90 Degree
        } else if theta == 0.0 && dx < 0 { // dy = 0
            theta = Double.pi // 180 degree
        } // else if theta == 0.0 && dx>= 0 { theta = 0.0 }
        
        print("dx = \(dx) and dy =\(dy) Angle: \(theta * 180 / Double.pi) ")
        return theta
    }
    
    // (1). CAAnimation
    private func rotateNode(node : SCNNode, theta : Double, with animation : Bool = false) {
        if animation {
            let rotation = CABasicAnimation(keyPath: "rotation")
            rotation.fromValue = SCNVector4Make(0,1,0,0) // along x-z plane
            rotation.toValue = SCNVector4Make(0,1,0,Float(theta))
            rotation.duration = 3.0
            rotation.repeatCount = Float.infinity
            node.addAnimation(rotation, forKey: "Rotate it")
        }
        node.rotation = SCNVector4Make(0, 1, 0, Float(theta))  // along x-z plane
        print("rotating node with angel :\(theta)")
    }
    
    // (2). addTexture using SCNAction
    private func addTexture(node : SCNNode, backward : Bool = false) {
        let toPow: Double = 3
        let timeDuration: Double = 15 / pow(2, toPow)
        let textureAction = SCNAction.customAction(duration: timeDuration) { (node, d) in
            let num = Int(Double(d) * pow(2, toPow)) + 1
            let imgName = backward ? "b\(num)" : "f\(num)"
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

