//
//  ViewController.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 12/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class BookLibrary: UIViewController {

    var model : [(name : String,tag :String)] = []
    var selectedData : (name : String, tag : String) = (String(),String())
    var dataSet : [Book] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationTitle()
        doParsing()
    }
    private func doParsing() {
        Parser.parseJSON { (books) in
            // It returns a [Book] list
            // Create the proper format models from Books : [Authors, Genre, Country]
            self.dataSet = books
            
            Parser.createModifiedModel(books: books,completionBlock: { [weak self] (arr) in
                // will get the result array
                // perform the UI
                self?.model = arr
                DispatchQueue.main.async {
                     self?.tableView.reloadData()
                } 
            })
        }
    }
    private func setNavigationTitle() {
        self.navigationItem.titleView = UILabel.getTitle(title: "Books Library")
    }
}
