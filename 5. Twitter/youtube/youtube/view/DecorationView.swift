//
//  DecorationView.swift
//  youtube
//
//  Created by Ashis Laha on 01/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class DecorationView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MyCustomLayout : UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        register(DecorationView.self, forDecorationViewOfKind: Constants.decorationView)
        scrollDirection = .vertical
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let att = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, with: indexPath)
        att.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        att.isHidden = false
        return att
    }
}
