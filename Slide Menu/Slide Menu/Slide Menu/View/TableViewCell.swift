//
//  TableViewCell.swift
//  Slide Menu
//
//  Created by Ashis Laha on 03/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet weak var name: UILabel! {
        didSet {
            name.numberOfLines = 0
            // this is important for auto resizing
            // This will increase the label height based on content.
            // This is similar to UITextView disabling Scroll enabled feature to increase the text view size.
            name.textColor = .black
            name.textAlignment = .left
            name.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    var model : User? {
        didSet {
            name.text = model?.name ?? ""
        }
    }
    
}
