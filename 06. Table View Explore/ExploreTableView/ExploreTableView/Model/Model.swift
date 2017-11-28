//
//  Model.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 01/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct Constants {
    static let cellID = "cell"
    static let headerID = "headerID"
    static let footerID = "footerID"
    static let desc : String = "I am Ashis, working on iOS Development mostly. Worked on Machine Learning, Tensorflow for Deep-learning, CoreML, ARKit, openCV etc.Please check my github projects. (username - ashislaha)"
    
    static let desc2 : String = "I am Ashis, working on iOS Development mostly. Worked on Machine Learning, Tensorflow for Deep-learning, CoreML, ARKit, openCV etc.Please check my github projects. (username - ashislaha). I created few apps based on ARKit and Machine learning. I am interested in TensorFlow which is used for Deep learning framework."
    static let desc3 = "My skills are \n Delivery Chat system using Firebase. \n UIKit/Core Graphics/Core Animation \n MapKit/Core Location/Core Motion/Google Maps \nAFNetworking etc..."
}

struct User {
    let profileImageName : String
    let name : String
    let username : String
    let bio : String
    var more : String
    var isExpand : Bool 
}

