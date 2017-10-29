//
//  HomeCell.swift
//  youtube
//
//  Created by Ashis Laha on 28/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeCell : UICollectionViewCell {
    
    var dataModel : Item? {
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
    
    private func viewSetup() {
        addSubview(userProfilePic)
        addSubview(name)
        addSubview(username)
        addSubview(bio)
        addSubview(followBtn)
        layoutSetup()
    }
    
    private func layoutSetup() {
        // adding constraints
        
        // user profile
        userProfilePic.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        userProfilePic.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        userProfilePic.heightAnchor.constraint(equalToConstant: 88).isActive = true
        userProfilePic.widthAnchor.constraint(equalToConstant: 88).isActive = true
        
        // name
        name.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        name.leftAnchor.constraint(equalTo: userProfilePic.rightAnchor, constant: 8).isActive = true
        name.rightAnchor.constraint(equalTo: followBtn.leftAnchor, constant: 0).isActive = true
        
        // username
        username.leftAnchor.constraint(equalTo: name.leftAnchor, constant: 0).isActive = true
        username.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 8).isActive = true
        username.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        
        // bio text
        bio.topAnchor.constraint(equalTo: userProfilePic.bottomAnchor, constant: 4).isActive = true
        bio.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        bio.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        bio.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8).isActive = true
        
        // followBtn
        followBtn.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        followBtn.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        followBtn.widthAnchor.constraint(equalToConstant: 88).isActive = true
        followBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
}
