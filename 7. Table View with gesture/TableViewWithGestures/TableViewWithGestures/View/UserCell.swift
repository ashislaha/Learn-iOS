//
//  UserCell.swift
//  ExploreTableView
//
//  Created by Ashis Laha on 01/11/17.
//  Copyright © 2017 Ashis Laha. All rights reserved.
//

import UIKit

protocol TasksUpdateDelegate {
    func delete(indexPath : IndexPath)
}


class UserCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private let gradient = CAGradientLayer()
    private var originalCenter = CGPoint()
    private var deleteOnDragRelease = false
    
    // used for delegation for deletion
    var indexPath : IndexPath?
    var delegate : TasksUpdateDelegate?
    
    private func viewSetup() {
        selectionStyle = .none
        // setup gradients
        gradient.frame = bounds
        gradient.colors = [UIColor(white: 1.0, alpha: 0.2).cgColor, UIColor(white: 1.0, alpha: 0.1).cgColor, UIColor(red: 0, green: 0, blue: 1, alpha: 0.2).cgColor]
        gradient.locations = [0.0, 0.01, 1.0]
        layer.insertSublayer(gradient, at: 0)
    }
    
    private func addPanGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        pan.delegate = self
        addGestureRecognizer(pan)
    }
    
    @objc func handlePan(gesture : UIPanGestureRecognizer) {

        switch gesture.state {
        case .began:
            originalCenter = center // center of cell
        
        case .changed:
            let translation = gesture.translation(in: self)
            center = CGPoint(x: translation.x + originalCenter.x, y: originalCenter.y)
            deleteOnDragRelease = frame.origin.x < (-frame.size.width / 2.0)
        
        case .ended:
            let originalFrame = CGRect(x: 0, y: frame.origin.y, width: bounds.size.width, height: bounds.size.height)
            if !deleteOnDragRelease { // back to original position
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame = originalFrame
                })
            } else { // delete the cell
                if let delegate = delegate, let indexPath = indexPath {
                    delegate.delete(indexPath: indexPath)
                }
            }
        default: break
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGesture = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let tranlation = panGesture.translation(in: superview!)
        return fabs(tranlation.x) > fabs(tranlation.y)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewSetup()
        addPanGesture()
    }
    
    var model : Task? {
        didSet {
            desc.text = model?.description ?? ""
        }
    }

    @IBOutlet weak var desc: UILabel! {
        didSet {
            desc.numberOfLines = 0
            // this is important for auto resizing
            // This will increase the label height based on content.
            // This is similar to UITextView disabling Scroll enabled feature to increase the text view size.
            desc.textColor = .black
            desc.textAlignment = .left
            desc.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
}



