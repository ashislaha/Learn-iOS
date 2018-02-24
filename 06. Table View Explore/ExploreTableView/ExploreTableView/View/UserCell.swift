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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewSetup()
    }
    
    var model : User? {
        didSet {
            profileImage.image = UIImage(named : model?.profileImageName ?? "profile")
            name.text = model?.name ?? ""
            username.text = model?.username ?? ""
            bio.text = model?.bio ?? ""
            more.text = model?.more ?? ""
        }
    }

    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = 5
            profileImage.layer.borderColor = UIColor.black.cgColor
            profileImage.clipsToBounds = true
            profileImage.layer.borderWidth = 3
        }
    }
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var more: UITextView! {
        didSet {
            more.textColor = .blue
            more.isScrollEnabled = false
            more.isUserInteractionEnabled = false
            more.text = "More to tapped"
        }
    }
    
    @IBOutlet weak var bio: UILabel! {
        didSet {
            bio.numberOfLines = 0
            // this is important for auto resizing
            // This will increase the label height based on content.
            // This is similar to UITextView disabling Scroll enabled feature to increase the text view size.
            bio.textColor = .black
            bio.textAlignment = .left
            bio.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    private func viewSetup() {
       // can do other set up here if you want.
        backgroundColor = .yellow
    }
}



