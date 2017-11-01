//
//  UserCell.swift
//  youtube
//
//  Created by Ashis Laha on 28/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

extension UIView {
    
    func anchors(top : NSLayoutYAxisAnchor?, topConstants : CGFloat, left : NSLayoutXAxisAnchor?, leftConstants : CGFloat, bottom : NSLayoutYAxisAnchor?, bottomConstants : CGFloat, right : NSLayoutXAxisAnchor?,  rightConstants : CGFloat, heightConstants : CGFloat, widthConstants : CGFloat ) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topConstants).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftConstants).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: bottomConstants).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: rightConstants).isActive = true
        }
        if heightConstants > 0 {
            self.heightAnchor.constraint(equalToConstant: heightConstants).isActive = true
        }
        if widthConstants > 0 {
            self.widthAnchor.constraint(equalToConstant: widthConstants).isActive = true
        }
    }
}


class UserCell : UICollectionViewCell {
    
    var dataModel : User? {
        didSet {
            userProfilePic.image = UIImage(named :dataModel?.profileImageName ?? "")
            name.text = dataModel?.name
            username.text = dataModel?.username
            bio.text = dataModel?.bio
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // user profile picture
    private let userProfilePic  : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // name
    private let name : UILabel = {
        let label = UILabel()
        label.text = "name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // username
    private let username : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // bio description
    private let bio : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    // follow button
    private let followBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.cyan.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.cyan, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // seperator
    private let seperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    
    private func viewSetup() {
        addSubview(userProfilePic)
        addSubview(name)
        addSubview(username)
        addSubview(bio)
        addSubview(followBtn)
        addSubview(seperatorView)
        layoutSetup()
    }
    
    private func layoutSetup() {
        // adding constraints
        
        // user profile
        userProfilePic.anchors(top: topAnchor, topConstants: 8, left: leftAnchor, leftConstants: 8, bottom: nil, bottomConstants: 0, right: nil, rightConstants: 0, heightConstants: 88, widthConstants: 88)
        
        // name
        name.anchors(top: topAnchor, topConstants: 8, left: userProfilePic.rightAnchor, leftConstants: 8, bottom: nil, bottomConstants: 0, right: followBtn.leftAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // username
        username.anchors(top: name.bottomAnchor, topConstants: 8, left: name.leftAnchor, leftConstants: 0, bottom: nil, bottomConstants: 0, right: name.rightAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // bio text
        bio.anchors(top: userProfilePic.bottomAnchor, topConstants: 8, left: leftAnchor, leftConstants: 8, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 0, widthConstants: 0)
        
        // followBtn
        followBtn.anchors(top: topAnchor, topConstants: 8, left: nil, leftConstants: 0, bottom: nil, bottomConstants: 0, right: rightAnchor, rightConstants: -8, heightConstants: 30, widthConstants: 88)
        
        // seperator view
        seperatorView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 1, widthConstants: 0)
    }
}
