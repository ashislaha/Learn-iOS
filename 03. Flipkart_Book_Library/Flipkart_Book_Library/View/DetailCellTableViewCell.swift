//
//  DetailCellTableViewCell.swift
//  Flipkart_Book_Library
//
//  Created by Ashis Laha on 12/10/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

class DetailCellTableViewCell: UITableViewCell {
    
    // add a NSCache for caching the images
    let cacheImages = NSCache<NSString, UIImage>()
    
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
    public var model : Book? {
        didSet {
            loaadImage(urlString: model?.image_url ?? "")
            title.text = model?.book_title ?? ""
            authors.text = model?.author_name ?? ""
            genre.text = model?.genre ?? ""
        }
    }

    private func loaadImage(urlString : String) {
        guard let url = URL(string: urlString), !urlString.isEmpty else { return }
        // check whether the image is present into cache or not
        if let image = cacheImages.object(forKey: NSString(string: urlString)) {
            imageVW.image = image
        } else {
            let session = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let data = data , error == nil else { return }
                DispatchQueue.main.async {
                    guard let image = UIImage(data: data) else { return }
                    self?.cacheImages.setObject(image, forKey: NSString(string: urlString)) // setting into cache
                    self?.imageVW.image = image
                }
            }
            session.resume()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
