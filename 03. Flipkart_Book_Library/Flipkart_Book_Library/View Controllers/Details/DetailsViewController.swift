//
//  DetailsViewController.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 12/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    public var model: [Book] = []
    public var navTitle: String?
    var filtered: [Book] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        tableViewSetup()
        setupSearch()
    }
    private func setNavigationTitle() {
        self.navigationItem.titleView = UILabel.getTitle(title: navTitle ?? "Details")
    }
    
    private func tableViewSetup() {
        // resize based on content
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.isUserInteractionEnabled = true
        tableView.reloadData()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search books"
        navigationItem.searchController = searchController // ios 11 feature
        definesPresentationContext = true
        // setup scope bar
        searchController.searchBar.scopeButtonTitles = ["All","The","Live"]
        searchController.searchBar.delegate = self
    }
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
