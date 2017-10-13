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

    //MARK:- Set title
    private func setNavigationTitle() {
        self.navigationItem.titleView = UILabel.getTitle()
    }
}

extension BookLibrary : UITableViewDataSource, UITableViewDelegate {
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(model[indexPath.row].name) is tapped ")
        selectedData = model[indexPath.row]
        performSegue(withIdentifier: "detail", sender: nil)
    }
}

extension BookLibrary {
    
    // Prepare Seque here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier , identifier == "detail" {
            if let destination = segue.destination as? UINavigationController {
                if let detailVC = destination.visibleViewController as? DetailsViewController {
                    
                    var details : [Book] = []
                    switch selectedData.tag {
                    case Constants.author :  details = Parser.getModelForName(books: dataSet, author: selectedData.name)
                    case Constants.genre:    details = Parser.getModelForName(books: dataSet, genre: selectedData.name)
                    case Constants.country:  details = Parser.getModelForName(books: dataSet, author_country: selectedData.name)
                    default:
                        break
                    }
                    detailVC.model = details
                }
            }
        }
    }
}

extension UILabel {
    
    static func getTitle() -> UILabel {
        // let's create some attributed string
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.0
        shadow.shadowOffset = CGSize(width: 3.0, height: 3.0)
        
        let attributedString = NSMutableAttributedString(string: "Books Library", attributes: [
            NSAttributedStringKey.foregroundColor : UIColor.red,   // text color
            NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20), // Font size
            NSAttributedStringKey.shadow : shadow // shadow effect
            ])
        let label = UILabel()
        label.attributedText = attributedString
        label.sizeToFit()
        return label
    }
}

