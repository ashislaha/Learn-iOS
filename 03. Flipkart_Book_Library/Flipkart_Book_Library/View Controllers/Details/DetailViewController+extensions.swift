//
//  DetailViewController+extensions.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 19/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

//MARK:- UITableViewDataSource
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
        cell.model = isFilteringActive() ? filtered[indexPath.row] : model[indexPath.row]
        return cell
    }
}

//MARK:- UITableViewDelegate
extension DetailsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

//MARK:- UISearchResultsUpdating
extension DetailsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        if let scopeText = searchBar.scopeButtonTitles?[searchBar.selectedScopeButtonIndex] { // when scope bar present
            filterSearchTextwithinScope(searchText: searchBar.text ?? "", scopeText: scopeText)
        } else {
            filterSearchTextwithinScope(searchText: searchBar.text ?? "")
        }
    }
}

//MARK:- UISearchBarDelegate
extension DetailsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterSearchTextwithinScope(searchText: searchBar.text ?? "", scopeText: searchBar.scopeButtonTitles?[selectedScope] ?? "all")
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

//MARK:- Helper private methods
extension DetailsViewController {
    private func isFilteringActive() -> Bool {
        let isSearchTextEmpty = isSearchBarEmpty()
        let isSearchBarScopeEmpty = searchController.searchBar.selectedScopeButtonIndex == 0
        return searchController.isActive && (!isSearchTextEmpty || !isSearchBarScopeEmpty)
    }
    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    private func filterSearchTextwithinScope(searchText : String, scopeText : String = "all") {
        filtered = model.filter({ (book) -> Bool in
            let isTypeMatch = scopeText.lowercased() == "all" || book.book_title.lowercased().contains(scopeText.lowercased())
            
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
}
