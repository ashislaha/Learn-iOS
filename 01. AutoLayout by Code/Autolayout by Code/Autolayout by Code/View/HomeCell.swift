//
//  HomeCell.swift
//  Autolayout by Code
//
//  Created by Ashis Laha on 29/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    var dataModel : HomeModel? {
        didSet {
            imageView.image = UIImage(named : dataModel?.imageName ?? "tree")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func viewSetup() {
        topView.addSubview(imageView)
        addSubview(topView)
        addSubview(textView)
        layoutSetup()
    }
    
    private var imageView : UIImageView = { // closure
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        imageView.contentMode = .scaleAspectFit
        return imageView
    }() // () is used to execute the closure
    
    private var topView : UIView = {
        let topView = UIView()
        topView.backgroundColor = .white
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
    
    
    //MARK:- Layout Setup
    private func layoutSetup() {
        
        // Configure topview , it will be the half of entire view
        topView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        topView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true    // leading space to view left
        topView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true  // trailing space to view right
        topView.topAnchor.constraint(equalTo: topAnchor).isActive = true      // top space to view top layout
        topView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true // bottom to text view
        
        // configure ImageView : It will be middle of topview
        imageView.centerXAnchor.constraint(equalTo: topView.centerXAnchor).isActive = true  // center x of topview
        imageView.centerYAnchor.constraint(equalTo: topView.centerYAnchor).isActive = true  // center y of topview
        imageView.heightAnchor.constraint(equalTo: topView.heightAnchor, multiplier: 0.5).isActive = true  // half of topview height
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true   // width of imageview = height of imageview
        
        // configure text view : It will be bottom of topview
        textView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true // leading
        textView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true // trailing
        textView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true // bottom
    }
    
    
}
