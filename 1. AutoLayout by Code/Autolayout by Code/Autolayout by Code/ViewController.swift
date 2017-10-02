//
//  ViewController.swift
//  Autolayout by Code
//
//  Created by Ashis Laha on 02/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var imageView : UIImageView = { // closure
        let imageView = UIImageView(image:UIImage(named: "tree"))
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.contentMode = .scaleAspectFit
        return imageView
    }() // () is used to execute the closure
    
    private var topView : UIView = {
        let topView = UIView()
        topView.translatesAutoresizingMaskIntoConstraints = false
        return topView
    }()
    
    private var textView : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.textAlignment = .center
        
        // let's create some attributed string
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.0
        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        let attributedString = NSMutableAttributedString(string: "This is begining of auto-layout learning", attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.red,   // text color
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 30), // Font size
                NSAttributedStringKey.shadow : shadow // shadow effect
            ])
        let anotherText = NSAttributedString(string: "\n\n\tWe will keep learning the iOS", attributes: [
                NSAttributedStringKey.foregroundColor : UIColor.blue,   // text color
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15), // Font size
            ])
        attributedString.append(anotherText)
        
        textView.attributedText = attributedString
        return textView
    }()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        topView.addSubview(imageView)
        view.addSubview(topView)
        view.addSubview(textView)
        layoutSetup()
    }
    
    //MARK:- Layout Setup
    private func layoutSetup() {
        
        // Configure topview , it will be the half of entire view
        topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true    // leading space to view left
        topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true  // trailing space to view right
        topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true      // top space to view top layout
        topView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true // bottom to text view
        
        // configure ImageView : It will be middle of topview
        imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true  // center x of topview
        imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true  // center y of topview
        imageView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5).isActive = true  // half of topview height
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true   // width of imageview = height of imageview
        
        // configure text view : It will be bottom of topview
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true // leading
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true // trailing
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true // bottom
    }
}








