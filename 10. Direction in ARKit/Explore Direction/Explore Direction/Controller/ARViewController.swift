//
//  ViewController.swift
//  Explore Direction
//
//  Created by Ashis Laha on 09/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation

class ARViewController: UIViewController {

    public var model : OlaLensModel?
    private var distanceUpdateTimer : Timer?
    
    // outlets
    @IBOutlet private weak var bottomView: UIStackView!
    @IBOutlet private weak var carRegNumberLabel: UILabel! {
        didSet {
            carRegNumberLabel.textColor = .white
        }
    }
    @IBOutlet private weak var carNumberLabel: UILabel! {
        didSet {
            carNumberLabel.textColor = .white
        }
    }
    @IBOutlet private weak var pickupPointLabel: UILabel! {
        didSet {
            pickupPointLabel.textColor = .white
        }
    }
    @IBOutlet private weak var distanceLabel: UILabel! {
        didSet {
            distanceLabel.textColor = .white
        }
    }
    
    @IBOutlet private weak var mapContainer: UIView! {
        didSet {
            mapContainer.layer.cornerRadius = mapContainer.frame.size.height / 2.0
            mapContainer.layer.borderWidth = 2.0
            mapContainer.layer.borderColor = UIColor.white.cgColor
            mapContainer.clipsToBounds = true
           
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnMap))
            mapContainer.addGestureRecognizer(tapGesture)
        }
    }
    
    // scene view
//    private var sceneView : OlaSceneView = {
//        let sceneView = OlaSceneView()
//        sceneView.translatesAutoresizingMaskIntoConstraints = false // enable auto-layout
//        return sceneView
//    }()
    
    // scene view
    private var sceneView : SceneLocationView = {
        let sceneView = SceneLocationView()
        sceneView.orientToTrueNorth = true
        sceneView.translatesAutoresizingMaskIntoConstraints = false
        return sceneView
    }()
    
    // black shadow view
    private let blackShadowView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        return view
    }()
    
    private func layoutSetup() {
        NSLayoutConstraint.activate([
            // scene view
            sceneView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sceneView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            // blackShadowView
            blackShadowView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            blackShadowView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            blackShadowView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            blackShadowView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15)
            ])
    }
    
    private func sceneViewSetup() {
        view.addSubview(sceneView)
        sceneView.addSubview(blackShadowView)
        sceneView.addSubview(bottomView)
        
        layoutSetup()
        sceneView.session.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnSceneView))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tappedOnMap() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func tappedOnSceneView() {
        UIView.animate(withDuration: 1.0) {
            self.mapContainer.alpha = 0.0
            self.mapContainer.alpha = 1.0
        }
        // find out node and do animation
        sceneView.scene.rootNode.childNodes.forEach({ (node) in
            let basicAnimation = CABasicAnimation(keyPath: "opacity")
            basicAnimation.fromValue = 0.0
            basicAnimation.toValue = 1.0
            basicAnimation.duration = 1.0
            node.addAnimation(basicAnimation, forKey: "opacity")
        })
    }
    
    private func updateModel() {
        carRegNumberLabel.text = model?.carRegisterNumber ?? ""
        carNumberLabel.text = model?.carNumber ?? ""
    }
    
    // add a timer to update the distance
    private func registerTimer() {
        if distanceUpdateTimer == nil {
            distanceUpdateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true, block: { [weak self] (timer) in
                if let appDelegate = UIApplication.shared.delegate as? AppDelegate, let distance = appDelegate.distance {
                    self?.distanceLabel.text = "\(Int(distance)) m"
                }
            })
        }
    }
    
    private func invalidateTimer() {
        distanceUpdateTimer?.invalidate()
        distanceUpdateTimer = nil
    }
    
    private func markOlaLensIntoShown() {
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: Constants.showIntro)
    }
    
    // View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewSetup()
        updateModel()
        //markOlaLensIntoShown()
        addNodesToScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.run()
        registerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.pause()
        invalidateTimer()
    }
   
    // adding a node
    private func addNodesToScene() {
        
        guard let sectionCoordinates = model?.sectionCoordinates, let endPosition = model?.carLocation , let appDelegate = UIApplication.shared.delegate as? AppDelegate, let userLocation = appDelegate.locationManager.location?.coordinate , !sectionCoordinates.isEmpty else { return }
        
        var prevLocation : CLLocationCoordinate2D = userLocation
        addOlaLensNode(location: prevLocation,previousLocation: sectionCoordinates.first!) // at user location
        
        for location in sectionCoordinates where distanceCheck(location1: prevLocation, location2: location) {
            addOlaLensNode(location: location,previousLocation: prevLocation)
            prevLocation = location
        }
        // at car position
        addOlaLensNode(location: endPosition, previousLocation: prevLocation,imageName: "logo")
        addOlaLensNode(location: endPosition, previousLocation: endPosition,imageName: "", downwards: true)
    }
    
/*
    private func addOlaLensNode(location : CLLocationCoordinate2D, previousLocation : CLLocationCoordinate2D, imageName : String = "", downwards : Bool = false) {
        guard let altitude = getLocationAltitude() else { return }
        
        if let image = UIImage(named: imageName) {
            let altitudeMatric = altitude + 1
            let nodeLocation = CLLocation(coordinate: location, altitude: altitudeMatric)
            let node = OlaLensNode(location: nodeLocation, image: image)
            node.scale = SCNVector3Make(3, 3, 3)
            sceneView.scene.rootNode.addChildNode(node)
            print("\n\n\(node.estimate.position)")
            
        } else {
            let nodeLocation = CLLocation(coordinate: location, altitude: altitude)
            var node : OlaLensNode!
            if !downwards {
                node = OlaLensNode(location: nodeLocation, image: nil)
                let theta = ARSetupUtility.shared.getAngle(location1: previousLocation, location2: location)
                ARSetupUtility.shared.rotateNode(node: node, theta: theta)
                print("\n\n\(node.estimate.position)")
            } else {
                node = OlaLensNode(location: nodeLocation, image: nil, downArrow: true)
                let billboardConstraint = SCNBillboardConstraint()
                billboardConstraint.freeAxes = .all
                node.constraints = [billboardConstraint] // make it focus to camera always
            }
            sceneView.scene.rootNode.addChildNode(node)
        }
    }

*/

    // While using SceneLocationView
    private func addOlaLensNode(location : CLLocationCoordinate2D, previousLocation : CLLocationCoordinate2D, imageName : String = "" , downwards : Bool = false) {
        guard let altitude = getLocationAltitude() else { return }
        
        if let image = UIImage(named: imageName) {
            let altitudeMatric = altitude + 1
            let nodeLocation = CLLocation(coordinate: location, altitude: altitudeMatric)
            let node =  LocationAnnotationNode(location: nodeLocation, image: image)
            node.scale = SCNVector3Make(3, 3, 3)
            node.scaleRelativeToDistance = true
            sceneView.addLocationNodeWithConfirmedLocation(locationNode: node)
           
        } else {
            let nodeLocation = CLLocation(coordinate: location, altitude: altitude)
            var node : OlaSceneNode!
            if !downwards {
                node = OlaSceneNode(location: nodeLocation)
                node.scaleRelativeToDistance = true
                let theta = ARSetupUtility.shared.getAngle(location1: previousLocation, location2: location)
                ARSetupUtility.shared.rotateNode(node: node, theta: theta)
            } else {
                node = OlaSceneNode(location: nodeLocation, downArrow : true)
                node.scaleRelativeToDistance = true
                let billboardConstraint = SCNBillboardConstraint()
                billboardConstraint.freeAxes = .all
                node.constraints = [billboardConstraint] // make it focus to camera always
            }
            sceneView.addLocationNodeWithConfirmedLocation(locationNode: node)
        }
    }

    
    private func setLookAtConstraint(previousNode : SCNNode, nextNode : SCNNode) {
        // previous node will follow next node, use SCNLookAtConstraint
        let constraint = SCNLookAtConstraint(target: nextNode)
        constraint.isGimbalLockEnabled = false
        previousNode.constraints = [constraint]
    }
    
    private func getLocationAltitude() -> CLLocationDistance? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.locationManager.location?.altitude
    }
    
    private func distanceCheck(location1 : CLLocationCoordinate2D, location2 : CLLocationCoordinate2D) -> Bool { // more than 10 meters
        return CLLocation(latitude: location1.latitude, longitude: location1.longitude).distance(from: CLLocation(latitude: location2.latitude, longitude: location2.longitude)) > 10
    }
}

// Session Delegate
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
    
    private func showAlert(header : String? = "Header", message : String? = "Message")  {
        let alertController = UIAlertController(title: header, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (alert) in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

