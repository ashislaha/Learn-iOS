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
import CoreLocation

@available(iOS 11.0, *)
class ARViewController: UIViewController {

    public var model : OlaLensModel?
    private let viewModel = ARViewModel()
    
    private var distanceFromUserlocationToDestination : CLLocationDistance? {
        didSet {
            if let distance = distanceFromUserlocationToDestination {
               distanceLabel?.text = "\(Int(distance)) m"
            }
        }
    }
    
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
    private var sceneView : OlaSceneView = {
        let sceneView = OlaSceneView()
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
        sceneView.sceneViewDelegate = self

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
        pickupPointLabel.text = model?.carUpdateLabel ?? ""
        if let _ = model?.carImage {
            // update car image
        }
    }
    
    // View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneViewSetup()
        updateModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.run()
        addNodesToScene()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.pause()
    }
   
    // adding a node
    private func addNodesToScene() {
        let nodes = viewModel.getSceneNodes(model: model)
        guard !nodes.isEmpty else { return }
        for node in nodes {
            sceneView.addLocationNodeWithConfirmedLocation(locationNode: node)
        }
    }
}

extension ARViewController : SceneLocationViewDelegate {
    func distanceFromUserlocationToDestination(distance: CLLocationDistance) {
        // get the distance from user location to destination
        distanceFromUserlocationToDestination = distance
    }
}

