//
//  HeaderCollectionReusableView.swift
//  CollectionViewExplore
//
//  Created by Ashis Laha on 26/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct HeaderModel {
    var name : String
}

class HeaderCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : HeaderModel? {
        didSet {
            addSubview(headerText)
            headerText.text = model?.name ?? ""
            layoutSetUp()
        }
    }
    
    let headerText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.sizeToFit()
        return label
    }()
    
    // setup autolayout
    private func layoutSetUp() {
        NSLayoutConstraint.activate([headerText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
                                     headerText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
                                   ])
    }
}

struct FooterModel {
    var name : String
}

class FooterCollectionReusableView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model : FooterModel? {
        didSet {
            addSubview(footerText)
            footerText.text = model?.name ?? ""
            layoutSetUp()
        }
    }
    
    let footerText : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.sizeToFit()
        return label
    }()
    
    // setup autolayout
    private func layoutSetUp() {
        footerText.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        footerText.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
    }
}

