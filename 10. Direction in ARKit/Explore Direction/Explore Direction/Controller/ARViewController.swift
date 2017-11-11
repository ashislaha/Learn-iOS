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
    
    // Scene Location View
    private var sceneLocationView : SceneLocationView = {
        let sceneLocationView = SceneLocationView()
        sceneLocationView.translatesAutoresizingMaskIntoConstraints = false
        sceneLocationView.orientToTrueNorth = true
        return sceneLocationView
    }()
    
    private let blackShadowView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        return view
    }()
    
    private func layoutSetup() {
        NSLayoutConstraint.activate([
            // sceneLocationView
            sceneLocationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            sceneLocationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            sceneLocationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            sceneLocationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // blackShadowView
            blackShadowView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            blackShadowView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            blackShadowView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            blackShadowView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15)
            ])
    }
    
    private func sceneViewSetup() {
        view.addSubview(sceneLocationView)
        sceneLocationView.addSubview(blackShadowView)
        sceneLocationView.addSubview(bottomView)
        
        layoutSetup()
        sceneLocationView.session.delegate = self
        sceneLocationView.locationDelegate = self
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
        sceneLocationView.sceneNode?.childNodes.forEach({ (node) in
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewSetup()
        locationAdded()
        updateModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneLocationView.run()
        registerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneLocationView.pause()
        invalidateTimer()
    }
    
    // Locations Added
    private func locationAdded() {
        guard let sectionCoordinates = model?.sectionCoordinates, let endPosition = model?.carLocation else { return }
        for location in sectionCoordinates {
            addNode(location: location,imageName: "pin")
        }
        addNode(location: endPosition, imageName: "carPosition")
    }
    
    private func getLocationAltitude() -> CLLocationDistance? {
        guard  let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDelegate.locationManager.location?.altitude
    }
    
    private func addNode(location : CLLocationCoordinate2D, imageName : String) {
        guard let altitude = getLocationAltitude() , let image = UIImage(named: imageName) else { return }
        print("altitude : \(altitude)")
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let location = CLLocation(coordinate: coordinate, altitude: altitude)
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.scaleRelativeToDistance = true
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
}

// Scene Location View Delegate
extension ARViewController : SceneLocationViewDelegate {
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        
    }
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
       
    }
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
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

