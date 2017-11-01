//
//  UserCell.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 01/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    var model : User? {
        didSet {
            profilePic.image = UIImage(named : model?.profileImageName ?? "")
            name.text = model?.name ?? ""
            username.text = model?.username ?? ""
            bio.text = model?.bio ?? ""
            more.text = model?.more ?? ""
            more.textColor = (model?.isExpand ?? false) ? .gray : .blue
        }
    }
    
    @IBOutlet private weak var profilePic: UIImageView!
    @IBOutlet private weak var name: UILabel! {
        didSet {
            name.font = UIFont.preferredFont(forTextStyle: .headline)
        }
    }
    @IBOutlet private weak var username: UILabel!
    @IBOutlet weak var bio: UILabel! {
        didSet {
            bio.numberOfLines = 0 // this is important for auto resizing
            // This will increase the label height based on content. This is similar to UITextView disabling Scroll enabled feature to increase the text view size.
            bio.textColor = .red
            bio.textAlignment = .left
            bio.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    @IBOutlet weak var more: UITextView! {
        didSet {
            more.isScrollEnabled = false
            more.isUserInteractionEnabled = false
            more.textColor = .blue
            
        }
    }
    
}

class HeaderView : UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .red
    }
}

class FooterView : UITableViewHeaderFooterView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .blue
    }
}


