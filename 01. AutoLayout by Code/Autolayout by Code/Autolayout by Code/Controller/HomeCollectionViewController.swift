//
//  HomeCollectionViewController.swift
//  Autolayout by Code
//
//  Created by Ashis Laha on 29/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeCollectionViewController: UICollectionViewController {
    
    var dataSource : [HomeModel] = [
        HomeModel(imageName: "tree", title: "", subTitle: ""),
        HomeModel(imageName: "tree", title: "", subTitle: ""),
        HomeModel(imageName: "tree", title: "", subTitle: "")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Explore Autolayout with CollectionView"
        collectionView?.backgroundColor = .white
        registerViews()
        pageControlSetup()
    }
    
    private func registerViews() {
        collectionView?.register(HomeCell.self, forCellWithReuseIdentifier: Constants.cellID)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.headerID)
        collectionView?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.footerID)
    }
    
    // add a page control with prev and next button
    private var prevBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Prev", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(prevBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var nextBtn : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(nextBtnTapped), for: .touchUpInside)
        return button
    }()
    
    private var pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .blue
        pageControl.currentPageIndicatorTintColor = .red
        return pageControl
    }()
    
    private var controlStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        return stack
    }()
    
    private func pageControlSetup() {
        
        pageControl.numberOfPages = dataSource.count
        controlStack.addArrangedSubview(prevBtn)
        controlStack.addArrangedSubview(pageControl)
        controlStack.addArrangedSubview(nextBtn)
        view.addSubview(controlStack)
        
        // add constraints
        controlStack.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 4).isActive = true
        controlStack.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -4).isActive = true
        controlStack.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        controlStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    @objc private func nextBtnTapped() {
        // change the page control
        let currentPage = pageControl.currentPage
        let nextPage = min(currentPage + 1, dataSource.count-1)
        pageControl.currentPage = nextPage
        
        // change the collection view next page
        let indexPath = IndexPath(item: nextPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc private func prevBtnTapped() {
        // change the page control
        let currentPage = pageControl.currentPage
        let nextPage = max(currentPage - 1, 0)
        pageControl.currentPage = nextPage
        
        // change the collection view next page
        let indexPath = IndexPath(item: nextPage, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    // scroll the collection view and update the page control at the same time
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / self.view.bounds.width)
        pageControl.currentPage = index
    }
}

// UICollectionViewDataSource
extension HomeCollectionViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellID, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        cell.dataModel = dataSource[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.headerID, for: indexPath)
            header.backgroundColor = .green
            return header
            
        } else if kind == UICollectionElementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.footerID, for: indexPath)
            footer.backgroundColor = .red
            return footer
            
        }
        return UICollectionReusableView()
    }
}

// UICollectionViewDelegate
extension HomeCollectionViewController  {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped : \(indexPath)")
    }
}

// UICollectionViewDelegateFlowLayout
extension HomeCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: view.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}


