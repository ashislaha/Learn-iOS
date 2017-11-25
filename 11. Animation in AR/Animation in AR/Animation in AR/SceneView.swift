//
//  SceneView.swift
//  Animation in AR
//
//  Created by Ashis Laha on 25/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import ARKit
import UIKit

public class SceneView : ARSCNView {
    
    private var configuration  : ARWorldTrackingConfiguration!
    
    //MARK: Setup
    
    public func run() {
        configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        session.run(configuration) // Run the view's session
    }
    
    public func pause() {
        session.pause()
    }
    
    public func resetConfig() {
        session.run(configuration, options: .resetTracking)
    }
    
    public func clearScene() {
        scene = SCNScene()
        resetConfig()
    }
}


