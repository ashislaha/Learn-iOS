//
//  SlideMenuViewController.swift
//  Slide Menu
//
//  Created by Ashis Laha on 03/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class SlideMenuViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        registers()
    }

    // model data
    var dataSource : [User] = [
        User(name: "Ashis"),
        User(name: "Deepanshu"),
        User(name: "Pushpak"),
        User(name: "Nihar"),
        User(name: "Arko"),
        User(name: "Prosen"),
        User(name: "Nitai"),
        User(name: "Chottu")
    ]
    
    private func tableViewSetup() {
        // resize based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    private func registers() {
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: Constants.headerID)
        tableView.register(FooterView.self, forHeaderFooterViewReuseIdentifier: Constants.footerID)
    }
}

extension SlideMenuViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.model = dataSource[indexPath.row]
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

extension SlideMenuViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped : \(indexPath)")
    }
}
