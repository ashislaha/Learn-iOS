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
    
    var model : [Book] = []
    var filtered : [Book] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        tableViewSetup()
        setupSearch()
    }
    
    private func setNavigationTitle() {
        self.navigationItem.titleView = UILabel.getTitle()
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
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "search books"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFilteringActive() -> Bool {
        let isSearchTextEmpty = isSearchBarEmpty()
        let isSearchBarScopeEmpty = searchController.searchBar.selectedScopeButtonIndex == 0
        return searchController.isActive && (!isSearchTextEmpty || !isSearchBarScopeEmpty)
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

// Data Source
extension DetailsViewController : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countVal = isFilteringActive() ? filtered.count : model.count
        return countVal
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DetailCellTableViewCell else { return UITableViewCell() }
        
        //guard let url = URL(string: filteredModel[indexPath.row].image_url), indexPath.row < filteredModel.count else { return UITableViewCell() }
        cell.model = isFilteringActive() ?  filtered[indexPath.row] : model[indexPath.row]
        return cell
    }
}

// Delegate
extension DetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(model[indexPath.row])")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// Search
extension DetailsViewController : UISearchResultsUpdating , UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let scopeText = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] {
            filterSearchTextwithinScope(searchText: searchBar.text ?? "", scopeText: scopeText)
        } else {
            filterSearchTextwithinScope(searchText: searchBar.text ?? "")
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterSearchTextwithinScope(searchText: searchBar.text ?? "", scopeText: searchBar.scopeButtonTitles![selectedScope])
    }
    
    private func filterSearchTextwithinScope(searchText : String, scopeText : String = "all") {
        filtered = model.filter({ (book) -> Bool in
            let isTypeMatch = scopeText.lowercased() == "all" //|| scopeText.lowercased() == task.type.lowercased()
            
            if isSearchBarEmpty() {
                return isTypeMatch
            } else {
                return isTypeMatch && book.book_title.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
            }
        })
        
        if !filtered.isEmpty {
            tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

