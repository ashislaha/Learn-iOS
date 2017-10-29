//
//  CustomCollectionViewCell.swift
//  CollectionViewExplore
//
//  Created by Ashis Laha on 26/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct CellModel {
    var imageName : String
    var imageTitle : String
}

class CustomCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .purple
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet private weak var imageVw: UIImageView! // this is giving me nil all the times, not sure why ????
    
    var model : CellModel? {
        didSet {
            //imageVw.image = UIImage(named : model?.imageName ?? "car_1")
            self.addSubview(imageView)
            imageView.image = UIImage(named : model?.imageName ?? "car_1")
            layoutSetup()
        }
    }
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private func layoutSetup() {
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
}
