//
//  DetailCellTableViewCell.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 12/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class DetailCellTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var imageVW: UIImageView! {
        didSet {
            imageVW.layer.cornerRadius = 5
            imageVW.layer.borderWidth = 2
            imageVW.layer.borderColor = UIColor.black.cgColor
        }
    }
    @IBOutlet private weak var title: UILabel! {
        didSet {
            title.numberOfLines = 0
            title.font = UIFont.systemFont(ofSize: 16)
        }
    }
    @IBOutlet private weak var authors: UILabel! {
        didSet {
            authors.numberOfLines = 0
            authors.font = UIFont.systemFont(ofSize: 12)
        }
    }
    @IBOutlet private weak var genre: UILabel! {
        didSet {
            genre.numberOfLines = 0
            genre.font = UIFont.systemFont(ofSize: 12)
        }
    }
    
    var model : Book? {
        didSet {
            imageVW.image = UIImage()
            title.text = model?.book_title ?? ""
            authors.text = model?.author_name ?? ""
            genre.text = model?.genre ?? ""
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
