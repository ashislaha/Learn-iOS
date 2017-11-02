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
        
        registers()
        tableViewSetup()
    }
    
    private func registers() {
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
        tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: Constants.footerID)
    }
    
    private func tableViewSetup() {
        // resize based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.headerID) as? HeaderView else{ return nil }
        header.viewSetup()
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constants.footerID) as? FooterView else {return nil }
        footerView.viewSetup()
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
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
        cell.model = dataSource[indexPath.row] // update the view
        
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

