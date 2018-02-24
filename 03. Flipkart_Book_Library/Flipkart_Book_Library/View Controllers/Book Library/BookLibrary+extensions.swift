//
//  BookLibrary+extensions.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 19/01/18.
//  Copyright © 2018 Ashis Laha. All rights reserved.
//

import UIKit

//MARK:- UITableViewDataSource
extension BookLibrary: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else { return UITableViewCell() }
        cell.textLabel?.text = model[indexPath.row].name
        return cell
    }
}

//MARK:- UITableViewDelegate
extension BookLibrary: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(model[indexPath.row].name) is tapped ")
        selectedData = model[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
    }
}

//MARK:- Prepare Segue here
extension BookLibrary {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier , identifier == "detail" {
            if let destination = segue.destination as? UINavigationController {
                if let detailVC = destination.visibleViewController as? DetailsViewController {
                    
                    let details : [Book] = Parser.getModel(books: dataSet, tagName: selectedData.tag, searchName: selectedData.name)
                    detailVC.model = details
                    detailVC.navTitle = selectedData.name
                }
            }
        }
    }
}
