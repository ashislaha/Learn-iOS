//
//  UIView+extensions.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 19/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

extension UILabel {
    
    static func getTitle(title: String) -> UILabel {
        // let's create some attributed string
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.0
        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        let attributedString = NSMutableAttributedString(string: title, attributes: [
            NSAttributedStringKey.foregroundColor : UIColor.red,   // text color
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), // Font size
            NSAttributedStringKey.shadow : shadow // shadow effect
            ])
        let label = UILabel()
        label.attributedText = attributedString
        label.sizeToFit()
        return label
    }
}
