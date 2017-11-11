//
//  ViewController.swift
//  TableViewWithGestures
//
//  Created by Ashis Laha on 02/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    // model data
    var dataSource : [Task] = [
        Task(description: "Task 1 : Complete Auto-layout by code", type : "p1"),
        Task(description: "Task 2 : Complete Collection view tutorials", type : "p1"),
        Task(description: "Task 3 : Complete Table View Tutorials", type : "p1"),
        Task(description: "Task 4 : Complete MapKit, ARKit", type : "p2"),
        Task(description: "Task 5 : Complete CoreML tutorials", type : "p2"),
        Task(description: "Task 6 : Complete TensorFlow for Deep learning", type : "p2"),
        Task(description: "Task 7 : Complete Push Notifications", type : "p3"),
        Task(description: "Task 8 : Complete Reactive Programming , Node.JS", type : "p3"),
        Task(description: "Task 9 : Complete OpenGL and OpenCV", type : "p2"),
        Task(description: "Task 10 : Complete Redux learning", type : "p3"),
        Task(description: "Task 11 : Complete RxSwift", type : "p3"),
        Task(description: "Task 12 : Complete fastline (Scan, Gym, Screenshots)", type : "p3")
    ]
    var filtered : [Task] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Table view with gestures and search"
        registers()
        tableViewSetup()
        searchSetup()
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
        tableView.contentInset = UIEdgeInsets(top: 0 , left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    private func searchSetup() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search"
        navigationItem.searchController = searchController // new in iOS 11
        definesPresentationContext = true
        // setup scope bar
        searchController.searchBar.scopeButtonTitles = ["All","p1","p2","p3"]
        searchController.searchBar.delegate = self
    }
    
    private func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFilteringActive() -> Bool {
        let isSearchTextEmpty = isSearchBarEmpty()
        let isSearchBarScopeEmpty = searchController.searchBar.selectedScopeButtonIndex == 0
        return searchController.isActive && (!isSearchTextEmpty || !isSearchBarScopeEmpty)
    }
}

//MARK:- Data Source
extension BaseViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilteringActive() {
            return filtered.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath) as? UserCell else { return UITableViewCell() }
        
        cell.model = isFilteringActive() ?  filtered[indexPath.row] : dataSource[indexPath.row]
        
        if !isFilteringActive() {
            cell.delegate = self
            cell.indexPath = indexPath
        }
        cell.backgroundColor = colorAtIndexPath(indexPath)
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

//MARK:- Delegate
extension BaseViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("cell tapped : \(indexPath)")
    }
}

//MARK:- Task delete delegate
extension BaseViewController : TasksUpdateDelegate {
    
    func delete(indexPath: IndexPath) {
        // delete the item from data source and reload the tableview
        guard indexPath.row < dataSource.count else { return }
        dataSource.remove(at: indexPath.row)
        
        // tableView.reloadData()
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .middle)
        tableView.endUpdates()
    }
}

//MARK:- Cell background color
extension BaseViewController {
    
    func colorAtIndexPath(_ indexPath : IndexPath) -> UIColor {
        let total = dataSource.count
        let greenVal = CGFloat(indexPath.row) / CGFloat(total) * 0.6
        return UIColor(red: 1.0, green: greenVal, blue: 0.0, alpha: 0.1)
    }
}

//MARK:- Search
extension BaseViewController : UISearchResultsUpdating , UISearchBarDelegate {
   
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
        filtered = dataSource.filter({ (task) -> Bool in
            let isTypeMatch = scopeText.lowercased() == "all" || scopeText.lowercased() == task.type.lowercased()
            
            if isSearchBarEmpty() {
                return isTypeMatch
            } else {
                return isTypeMatch && task.description.lowercased().contains(searchController.searchBar.text?.lowercased() ?? "")
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


