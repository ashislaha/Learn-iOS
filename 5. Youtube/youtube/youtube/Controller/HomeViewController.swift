//
//  ViewController.swift
//  youtube
//
//  Created by Ashis Laha on 28/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

let desc : String = "I am Ashis, working on iOS Development mostly. Worked on Machine Learning, Tensorflow for Deep-learning, CoreML, ARKit, openCV etc.Please check my github projects. (username - ashislaha)"

class HomeViewController: UICollectionViewController {
    
    var dataSource : [User] = [
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: desc),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: desc),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: desc),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: desc)
    ]
    
    var tweets : [Tweet] = {
        
        let user = User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: desc)
        let tweet1 = Tweet(user: user, message: "This is a new tweet message. We are trying to learn iOS with collection view")
        let tweet2 = Tweet(user: user, message: "This is a new tweet message. We are trying to learn iOS with collection view")
        return [tweet1, tweet2]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        title = "Tweeter"
        registerViews()
    }
    
    private func registerViews() {
        collectionView?.register(UserCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView?.register(TweetCell.self, forCellWithReuseIdentifier: Constants.tweetID)
        
        collectionView?.register(UserHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.headerID)
        collectionView?.register(UserFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.footerID)
    }
    
}

// UICollectionViewDataSource
extension HomeViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return tweets.count
        }
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.tweetID, for: indexPath) as? TweetCell else { return UICollectionViewCell() }
            cell.model = tweets[indexPath.row]
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? UserCell else { return UICollectionViewCell() }
        cell.dataModel = dataSource[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerID, for: indexPath)
            return header
            
        } else if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerID, for: indexPath)
            return footer

        }
        return UICollectionReusableView()
    }
    
}

// UICollectionViewDelegate
extension HomeViewController  {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped : \(indexPath)")
    }
}

// UICollectionViewDelegateFlowLayout
extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 { return .zero }
        return CGSize(width: self.view.frame.width, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 { return .zero }
        return CGSize(width: self.view.frame.width, height: 50)
    }
}
