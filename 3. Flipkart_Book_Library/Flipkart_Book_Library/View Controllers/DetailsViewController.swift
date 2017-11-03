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
    
    @IBOutlet weak var search: UISearchBar! {
        didSet { search.delegate = self }
    }
    
    var model : [Book] = []
    var filteredModel : [Book] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        setupSearch()
    }
    
    private func setupSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "search books"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK:- Set title
    private func setNavigationTitle() {
        self.navigationItem.titleView = UILabel.getTitle()
    }
    
    @IBAction func backAction(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let isEmptyStr = search.text?.isEmpty, isEmptyStr {
            return  model.count
        }
        return filteredModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? DetailCellTableViewCell else { return UITableViewCell() }
        
        if let isEmptyStr = search.text?.isEmpty, isEmptyStr {
            // cell setup While Seach is empty
            
            guard let url = URL(string: model[indexPath.row].image_url) else { return UITableViewCell() }
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async { [weak self] in
                    cell.imageVW = UIImageView(image: UIImage(data : data))
                    cell.title.text = self?.model[indexPath.row].book_title
                    cell.authors.text = self?.model[indexPath.row].author_name
                    cell.genre.text = self?.model[indexPath.row].genre
                }
            }
        } else {
            // cell setup While Seach is going on
            
            guard let url = URL(string: filteredModel[indexPath.row].image_url) else { return UITableViewCell() }
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: url) else { return }
                DispatchQueue.main.async { [weak self] in
                    cell.imageVW = UIImageView(image: UIImage(data : data))
                    cell.title.text = self?.filteredModel[indexPath.row].book_title
                    cell.authors.text = self?.filteredModel[indexPath.row].author_name
                    cell.genre.text = self?.filteredModel[indexPath.row].genre
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(model[model.index(model.startIndex, offsetBy: indexPath.row)]) is tapped ")
    }
}

extension DetailsViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // use filter of model to get the results
        // reload the table view with filtered results
        // We can optimize here using some throttle / threshold, instead of seaching everytime searchText changes
        
        print("Search text : \(searchText)")
        let filtered = model.filter{
            $0.book_title.contains(searchText)
        }
        if !filtered.isEmpty {
            filteredModel = filtered
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
}

extension DetailsViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    // scope bar
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }

    
}




