//
//  OlaLensModel.swift
//  Explore Direction
//
//  Created by Ashis Laha on 11/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

struct Constants {
    static let showIntro = "showIntro"
    static let storyboardName = "ARKit"
    static let detectingHeaderText = "Detecting your \nSurrounding ..."
    static let detectingFooterText = "\n\nPlease move around slowly to calibrate your Ola Lens"
    static let surroundingViewBackgroundColor = UIColor.black.withAlphaComponent(0.55)
    static let polylineColor = UIColor(red: CGFloat(1 / 255.0), green: CGFloat(179 / 255.0), blue: CGFloat(253 / 255.0), alpha: CGFloat(1.0))
}

class OlaLensModel {
    
    var carRegisterNumber : String?
    var carNumber : String?
    var carLocation : CLLocationCoordinate2D?
    var sectionCoordinates : [CLLocationCoordinate2D]?
}
