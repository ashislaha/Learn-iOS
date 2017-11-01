//
//  ViewController.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 01/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // model data
    var dataSource : [User] = [
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: Constants.desc, more : "More to tapped", isExpand: false),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: Constants.desc, more: "More to tapped", isExpand: false),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: Constants.desc2, more: "More to tapped", isExpand: false),
        User(profileImageName: "profile", name: "Ashis Laha", username: "@ashislaha", bio: Constants.desc, more: "More to tapped", isExpand: false)
    ]
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // resize based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.reloadData()
    }
    
    private func registers() {
        tableView.register(UserCell.self, forCellReuseIdentifier: Constants.cellID)
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
        tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: Constants.footerID)
    }
}

extension HomeViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? UserCell else { return UITableViewCell() }
        cell.model = dataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped : \(indexPath)")
        
        // expand cell while tapping the cell
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        // model
        dataSource[indexPath.row].isExpand = !dataSource[indexPath.row].isExpand
        dataSource[indexPath.row].more =  dataSource[indexPath.row].isExpand ? Constants.desc3 : "More to tapped"
        
        cell.model = dataSource[indexPath.row] // call the cell
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

