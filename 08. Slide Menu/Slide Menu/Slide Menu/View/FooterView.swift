//
//  FooterView.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 02/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class FooterView : UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewSetup()
    }
    
    private let footerLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Footer"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.backgroundColor = .purple
        return label
    }()
    
    func viewSetup() {
        addSubview(footerLabel)
        
        NSLayoutConstraint.activate([
            footerLabel.topAnchor.constraint(equalTo: topAnchor),
            footerLabel.leftAnchor.constraint(equalTo: leftAnchor),
            footerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            footerLabel.rightAnchor.constraint(equalTo: rightAnchor)
            ])
    }
}


