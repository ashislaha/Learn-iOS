//
//  HeaderView.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 02/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HeaderView : UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let profilePic : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false // enable auto layout
        imageView.layer.cornerRadius = 5
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.clipsToBounds = true
        imageView.backgroundColor = .yellow
        imageView.image = UIImage()
        return imageView
    }()
    
    private let headerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "To Do List"
        label.textColor = .purple
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }()
    
    func viewSetup() {
        addSubview(headerLabel)
        addSubview(profilePic)
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
            //headerLabel.rightAnchor.constraint(equalTo: rightAnchor),
            
            //profilePic.rightAnchor.constraint(equalTo: headerLabel.leftAnchor, constant: 5),
            profilePic.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            profilePic.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            profilePic.heightAnchor.constraint(equalToConstant: 44),
            profilePic.widthAnchor.constraint(equalToConstant: 44)
            
            ])
    }
}
