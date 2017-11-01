//
//  TweetCell.swift
//  youtube
//
//  Created by Ashis Laha on 30/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class TweetCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : Tweet? {
        didSet {
            userProfilePic.image = UIImage(named : model?.user.profileImageName ?? "")
            
            // name
            let attributedText = NSMutableAttributedString(string: model?.user.name ?? "", attributes: [
                NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16),
                NSAttributedStringKey.strokeColor : UIColor.brown
                ])
            
            // username
            let username = "  \(model?.user.username ?? "") \n\n"
            attributedText.append(NSAttributedString(string: username, attributes: [
                NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.strokeColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 0.5)
                ]))
            attributedText.append(NSAttributedString(string: model?.message ?? ""))
            desc.attributedText = attributedText
        }
    }
    
    // user profile picture
    private let userProfilePic  : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // tweet description
    private let desc : UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // seperator
    private let seperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return view
    }()
    
    // controls stack view
    private let stackView : UIStackView = {
        let redView = UIView()
        redView.backgroundColor = .red
        let icon1 = UIButton()
        icon1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon1.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        redView.addSubview(icon1)
        
        let greenView = UIView()
        greenView.backgroundColor = .green
        let icon2 = UIButton()
        icon2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon2.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        greenView.addSubview(icon2)
        
        let blueView = UIView()
        blueView.backgroundColor = .blue
        let icon3 = UIButton()
        icon3.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon3.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        blueView.addSubview(icon3)

        let purpleView = UIView()
        purpleView.backgroundColor = .purple
        let icon4 = UIButton()
        icon4.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        icon4.setImage(#imageLiteral(resourceName: "icon"), for: .normal)
        purpleView.addSubview(icon4)
        
        let stack = UIStackView(arrangedSubviews: [redView, greenView, blueView, purpleView])
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        
        return stack
    }()
    
    private func setupView() {
        addSubview(userProfilePic)
        addSubview(desc)
        addSubview(seperatorView)
        addSubview(stackView)
        
        layoutSetup()
    }
    
    private func layoutSetup() {
        // profile image
        userProfilePic.anchors(top: topAnchor, topConstants: 8, left: leftAnchor, leftConstants: 0, bottom: nil, bottomConstants: 0, right: desc.leftAnchor, rightConstants: 8, heightConstants: 88, widthConstants: 88)
        // desc
        desc.anchors(top: topAnchor, topConstants: 8, left: nil, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: -8, heightConstants: 0, widthConstants: 0)
        // seperator view
        seperatorView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 1, widthConstants: 0)
        
        // stack view
        stackView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 40, widthConstants: 0)
        
    }
}
