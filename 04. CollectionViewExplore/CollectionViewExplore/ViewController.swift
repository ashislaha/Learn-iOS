//
//  ViewController.swift
//  CollectionViewExplore
//
//  Created by Ashis Laha on 26/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

struct Constants {
    static let numberOfItems : CGFloat = 3
    static let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let headerSectionReusableIdentifier = "header"
    static let footerSectionReusableIdentifier = "footer"
    static let cellIdentifier = "collectionViewCell"
}

class ViewController: UIViewController {

    private var isInteractiveMode = false
    private var source : IndexPath = IndexPath(item: 0, section: 0)
    private var destination : IndexPath = IndexPath(item: 0, section: 0)
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
                collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.headerSectionReusableIdentifier)
                collectionView.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.footerSectionReusableIdentifier)
                collectionView.backgroundColor = .white
                collectionView.isPagingEnabled = true
            
                // create a flow layout here and assign to it
//                let layout = UICollectionViewFlowLayout()
//                layout.scrollDirection = .horizontal
//                collectionView.collectionViewLayout = layout
        }
    }
    
    /*
         If we use CollectionViewController then no need to add gesture, just update property isInstallsStandardGestureForInteractiveMovement = true ,
         call the dataSource method moveItemAt(source, destination)
     */
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress(gesture:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc private func longPress(gesture : UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexpath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else { break }
            collectionView.beginInteractiveMovementForItem(at: indexpath)
            
        case .changed :
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            
        case .ended:
            collectionView.endInteractiveMovement()
            
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
}

extension ViewController : UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? CustomCollectionViewCell else { return UICollectionViewCell() }
        
        cell.model =  isInteractiveMode ? CellModel(imageName: "car_\(source.row+1)", imageTitle: "Car") : CellModel(imageName: "car_\(indexPath.row+1)", imageTitle: "Car")
        isInteractiveMode = false // once done user interactive
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerSectionReusableIdentifier, for: indexPath) as? HeaderCollectionReusableView else { return UICollectionReusableView() }
            header.model = HeaderModel(name: "Header")
            return header
            
        } else if kind == UICollectionElementKindSectionFooter {
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerSectionReusableIdentifier, for: indexPath) as? FooterCollectionReusableView else { return UICollectionReusableView() }
            footer.model = FooterModel(name: "Footer")
            return footer
        }
        return UICollectionReusableView()
    }
    
    // Interactive movements 
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        isInteractiveMode = true
        source = sourceIndexPath
        destination = destinationIndexPath
        // best way to do is to update the model so that next time while scrolling the collection view, it will not reset the items.
    }
}

extension ViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("seleceted \(indexPath)")
    }
}

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.edgeInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = Constants.edgeInsets.left * (Constants.numberOfItems + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / Constants.numberOfItems
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
}

