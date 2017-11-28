//
//  UserHeaderFooterViewCollectionReusableView.swift
//  youtube
//
//  Created by Ashis Laha on 30/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class UserHeaderView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.sepratorColor
        viewSetups()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Users"
        return label
    }()
    
    // seperator
    private let seperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.sepratorColor
        return view
    }()
    
    private func viewSetups() {
        addSubview(label)
        addSubview(seperatorView)
        
        // add constraints
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        seperatorView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 1, widthConstants: 0)
    }
}

class UserFooterView : UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Constants.sepratorColor
        viewSetups()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // seperator
    private let seperatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.sepratorColor
        return view
    }()
    
    private let label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Follow More"
        return label
    }()
    
    private func viewSetups() {
        addSubview(label)
        addSubview(seperatorView)
        
        // add constraints
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        seperatorView.anchors(top: nil, topConstants: 0, left: leftAnchor, leftConstants: 0, bottom: bottomAnchor, bottomConstants: 0, right: rightAnchor, rightConstants: 0, heightConstants: 1, widthConstants: 0)
    }
}


