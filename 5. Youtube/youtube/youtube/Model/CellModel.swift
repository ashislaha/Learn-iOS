//
//  CellModel.swift
//  youtube
//
//  Created by Ashis Laha on 28/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct Constants {
    static let cellID = "cellID"
    static let tweetID = "tweetID"
    static let headerID = "headerID"
    static let footerID = "footerID"
}

struct User {
    let profileImageName : String
    let name : String
    let username : String
    let bio : String
}

struct Tweet {
    let user : User
    let message : String
}
